class UserMailer < ApplicationMailer
  require 'icalendar'
  
  default :from => 'dcordz2@gmail.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def welcome(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'Thanks for signing up to build this city. We are build this city.',
    :template_name => 'welcome')
  end

  # 5th user has created project, send date, time, location and attached calendar thing to all users
  def start_project(users, project)
    @users = users
    @project = project
    # headers['X-SMTPAPI'] = { :to => @users }.to_json
    attachments['elm_counter.elm'] = File.read('/Users/david/TryElm/elm_counter.elm')

    mail(
     :to => @users,
     :subject => "Get Ready to Build! #{@project.project_type} at #{@project.street1} and #{@project.street2}",
     :template_name => "start_project" )
  end

  # when a user joins a project before the action date and when there are already 5 on the project
  def new_user_on_project(user, project)
    @user = user
    @project = project

    attachments['elm_counter.elm'] = File.read('/Users/david/TryElm/elm_counter.elm')

    mail( :to => @user.email,
    :subject => "Get Ready to Build! #{@project.project_type} at #{@project.street1} and #{@project.street2}",
    :template_name => 'new_user_on_project')
  end
end
