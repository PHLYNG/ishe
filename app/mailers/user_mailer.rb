class UserMailer < ApplicationMailer

  default :from => 'ishe.build@gmail.com'

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

    ical = Icalendar::Calendar.new
    ishe_project = Icalendar::Event.new
    ishe_project.dtstart = @project.project_action_date
    ishe_project.summary = "Get ready to work on the #{@project.project_type} at #{@project.street1} and #{@project.street2}"
    ishe_project.location = "#{@project.street1} and #{@project.street2}, Baltimore, MD"
    ical.add_event(ishe_project)
      ishe_project.alarm do |a|
        a.action  = "DISPLAY" # This line isn't necessary, it's the default
        a.summary = "Alarm notification"
        a.trigger = "-P1DT0H0M0S" # 1 day before
      end

      ishe_project  .alarm do |a|
        a.action        = "AUDIO"
        a.trigger       = "-PT15M"
        a.append_attach "Basso"
      end

    ical.publish

    attachments['ishe_project.ics'] = { mime_type: "text/calendar", content: ical.to_ical }

    mail(
     :to => @users,
     :subject => "Get Ready to Build! #{@project.project_type} at #{@project.street1} and #{@project.street2}",
     :template_name => "start_project" )
  end

  # when a user joins a project before the action date and when there are already 5 on the project
  def new_user_on_project(user, project)
    @user = user
    @project = project

    ical = Icalendar::Calendar.new
    ishe_project = Icalendar::Event.new
    ishe_project.dtstart = @project.project_action_date
    ishe_project.summary = "Get ready to work on the #{@project.project_type} at #{@project.street1} and #{@project.street2}"
    ishe_project.location = "#{@project.street1} and #{@project.street2}, Baltimore, MD"
    ical.add_event(ishe_project)
      ishe_project.alarm do |a|
        a.action  = "DISPLAY" # This line isn't necessary, it's the default
        a.summary = "Alarm notification"
        a.trigger = "-P1DT0H0M0S" # 1 day before
      end

      ishe_project  .alarm do |a|
        a.action        = "AUDIO"
        a.trigger       = "-PT15M"
        a.append_attach "Basso"
      end

    ical.publish

    attachments['ishe_project.ics'] = { mime_type: "text/calendar", content: ical.to_ical }

    mail( :to => @user.email,
          :subject => "Get Ready to Build! #{@project.project_type} at #{@project.street1} and #{@project.street2}",
          :template_name => 'new_user_on_project')
  end
end
