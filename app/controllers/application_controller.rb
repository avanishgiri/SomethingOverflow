class ApplicationController < ActionController::Base
  protect_from_forgery

  def create_session(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def store_return_to
    session[:return_to] = request.referer unless session[:return_to]
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
