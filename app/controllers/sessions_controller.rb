# HTTP is a stateless protocol, treating each request as an independent transaction that is unable to use information from any previous requests. This means there is no way within the hypertext transfer protocol to remember a user’s identity from page to page; instead, web applications requiring user login must use a session, which is a semi-permanent connection between two computers (such as a client computer running a web browser and a server running Rails).
#
# The most common techniques for implementing sessions in Rails involve using cookies, which are small pieces of text placed on the user’s browser. Because cookies persist from one page to the next, they can store information (such as a user id) that can be used by the application to retrieve the logged-in user from the database.
#
# It’s convenient to model sessions as a RESTful resource: visiting the login page will render a form for new sessions, logging in will create a session, and logging out will destroy it. Unlike the Users resource, which uses a database back-end (via the User model) to persist data, the Sessions resource will use cookies, and much of the work involved in login comes from building this cookie-based authentication machinery.
#
# The elements of logging in and out correspond to particular REST actions of the Sessions controller: the login form is handled by the new action (covered in this section), actually logging in is handled by sending a POST request to the create action (Section 8.2), and logging out is handled by sending a DELETE request to the destroy action (Section 8.3). (Recall the association of HTTP verbs with REST actions from Table 7.1.)

class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      # call log_in helper method and pass user as argument
      log_in user
      redirect_to user
    else
      flash.now[:danger] = "Error loggin in, please check your username and password and try again."

      render 'new'

      # the above is incorrect without the ".now" because re-rendering a template with render doesn’t count as a request, and flash persist across the site-layout until a new request is made
      #
    end
    #
  end

  def destroy
    log_out
    redirect_to root_url
  end

end
