class UsersController < ApplicationController
  #ログインユーザーのみアクセス可能
  before_action :authenticate_user,{only: [:index, :show, :edit, :update]}
  #ログインユーザーはアクセスできない
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  #異なるユーザー情報の編集をさせない
  before_action :ensure_correct_user, {only: [:edit, :update]}

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params_permit)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー情報を登録しました"
      redirect_to users_path
    else
      render action:  :new
    end

  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    if @user.save
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to user_path
    else
      render action: :edit
    end
  end

  def login_form

  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to users_path
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render action: :login_form
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to login_path
  end


  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "情報編集の権限がありません"
      redirect_to users_path
    end
  end

  private
  def params_permit
    params.require(:user).permit(:name, :email, :password)
  end

end
