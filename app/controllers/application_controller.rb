class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  # by including helper module, make helper functions available in all views
  include SessionsHelper
end
