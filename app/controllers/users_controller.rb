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
  end

  def create
    @user = User.new(user_params)
    # if user is valid
    if @user.save
      # send user welcome email
      UserMailer.welcome(@user).deliver
      binding.pry
      # log in that user
      log_in @user
      # flash message welcome
      flash[:success] = "Welcome to Ishe, ready to get to work?"
      # redirect to user page
      redirect_to @user
    else
      # if user save fails, render the new user registration page
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @projects = current_user.projects
    respond_to do |format|
      format.html
      format.json { render json: [@user, @projects], status: :created, location: @user }
    end
  end

#########################################

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
