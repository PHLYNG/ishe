class UserMailer < ApplicationMailer
  default :from => 'dcordz2@gmail.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def welcome(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'Thanks for signing up for our amazing app' )
  end
end


end


#   include SendGrid
#   sendgrid_category :use_subject_lines
#   # sendgrid_enable   :opentrack, :ganalytics
#   sendgrid_unique_args :key1 => "value1", :key2 => "value2"
#
#   def welcome_message(user)
#     sendgrid_category "Welcome"
#     sendgrid_unique_args :key2 => "newvalue2", :key3 => "value3"
#     mail :to => user.email, :subject => "Welcome #{user.name} :-)"
#   end
#
#   def goodbye_message(user)
#     # sendgrid_disable :ganalytics
#     mail :to => user.email, :subject => "Fare thee well :-("
#   end
# end
