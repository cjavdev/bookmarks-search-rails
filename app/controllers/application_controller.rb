class ApplicationController < ActionController::Base

  def require_user!
    if !current_user
      redirect_to '/'
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
