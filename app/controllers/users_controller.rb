class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # if user is valid


    respond_to do |format|
      if @user.save
        # Tell the UserMailer to send a welcome email after save
        log_in(@user)
        uservar = UserMailer.welcome_email(@user).deliver_now
        format.html { redirect_to(@user, notice: 'Welcome to Ishe, ready to get to work?') }
        format.json { render json: @user, status: :created, location: @user }
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
  end

#########################################

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
