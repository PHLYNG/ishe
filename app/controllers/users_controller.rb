class UsersController < ApplicationController

  def index
    @users = User.all
    respond_to do |format|
      format.html
      # render to html/json sure but without the password digest? How to hide?
      format.json { render json: @users, status: :ok, location: users_path }
    end
  end

  def new
    @user = User.new
    if current_user
      flash[:warning] = "You are already logged in. In order to create an account you must first log out."
      redirect_to current_user
    end
  end

  def create
    @user = User.new(user_params)
    # if user is valid
    if @user.save
      # send user welcome email
      UserMailer.welcome(@user).deliver
      # log in that user
      log_in @user
      # flash message welcome
      flash[:success] = "Welcome to Ishé, ready to get to work?"
      # redirect to user page
      redirect_to @user
    else
      # if user save fails, render the new user registration page
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    # @projects = current_user.projects
    @projects = @user.projects
    unless @user.id == current_user.id
      flash[:danger] = "You can only view your user profile!"
      redirect_to current_user
    else
    respond_to do |format|
      format.html {}
      format.json { render json: [@user,@projects], status: :ok }
    end
  end
  end

  def edit
    @user = User.find(params[:id])
    unless @user.id == current_user.id
      flash[:danger] = "You can only edit your user profile!"
      redirect_to current_user
    end
  end

  def update
    @user = User.find(params[:id])
    unless @user.id == current_user.id
      flash[:danger] = "You can only update your user profile!"
      redirect_to current_user
    else
      @user.update_attributes(user_params)
      redirect_to @user
    end
  end

#########################################

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :photo, :motto, :uid, :provider)
  end
end
