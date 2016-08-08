class UserMailer < ApplicationMailer
  default from: 'from@example.com'
  def welcome_email(user)
      @user = user
      @url  = 'http://example.com/Login'
      mail(to: @user.email, subject: 'Welcome to My Awesome Site')
   end
end
