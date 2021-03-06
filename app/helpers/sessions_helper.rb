module SessionsHelper
  # session method is defined by Rails and can be used as if it were a hash
  # this method places a temp cookie in the user's browser containing an encrypted id
  # this temp cookie expires and is destroyed when the user closes the browser
  # temp cookies are encrypted and secure and not susceptible to session hijacking attacks

  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # to reference currently logged in user
  def current_user
    # idiomatically incorrect ruby
    # @current_user = @current_user || User.find_by(id: session[:user_id])

    # idiomatically correct ruby
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # make sure current_user is logged in
  def logged_in?
    !current_user.nil?
  end

  # delete the user session/cookie? and then set the current user method to nil
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

end
