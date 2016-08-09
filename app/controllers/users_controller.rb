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

    respond_to do |format|
      # if user is valid
      if @user.save
        # Tell the UserMailer to send a welcome email after save
        log_in(@user)
        uservar = UserMailer.welcome_email(@user).deliver_now
        format.html { redirect_to(@user, notice: 'Welcome to Ishe, ready to get to work?') }
        format.json { render json: @user, status: :created, location: user_path }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end



    # if @user.save
      # Tell the ApplicationMailer to send a welcome email after save
      # UserMailer.welcome_email(@user).deliver_now
      # log in that user
      # log_in @user
      # flash message welcome
      # flash[:success] = "Welcome to Ishe, ready to get to work?"
      # redirect to user page
      # redirect_to @user
    # else
      # if user save fails, render the new user registration page
      # render 'new'
    # end
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
