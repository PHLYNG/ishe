class UserMailer < ApplicationMailer
  include SendGrid
  sendgrid_category :use_subject_lines
  # sendgrid_enable   :opentrack, :ganalytics
  sendgrid_unique_args :key1 => "value1", :key2 => "value2"

  def welcome_message(user)
    @url = "https://mysterious-sea-27623.herokuapp.com/"
    sendgrid_category "Welcome"
    sendgrid_unique_args :key2 => "newvalue2", :key3 => "value3"
    mail :to => user.email, :subject => "Welcome #{user.name} :-)"
  end

  def goodbye_message(user)
    # sendgrid_disable :ganalytics
    mail :to => user.email, :subject => "Fare thee well :-("
  end
end
