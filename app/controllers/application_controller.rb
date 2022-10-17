class ApplicationController < ActionController::Base
  helper_method :logged_in?

  def require_user!
    if !current_user
      redirect_to '/'
    end
  end

  def require_subscribed_user!
    if !current_user.subscribed?
      redirect_to "/checkout"
    end
  end

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
