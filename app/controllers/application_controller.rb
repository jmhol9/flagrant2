class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

   helper_method :current_user, :external_page?, :logged_in?, :response_has_errors?, :admin?

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def external_page? 
    params[:controller] == 'statics' || 
    params[:controller] == 'sessions' ||
    (params[:controller] == 'users' && params[:action] == "new" )
  end

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def login!(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
  end

  def logged_in?
    !current_user.nil?
  end

  def admin?
    current_user.admin
  end

  def response_has_errors?
    !flash.now[:errors].nil?
  end

  def redirect_unless_logged_out
    redirect_to user_url(current_user) if logged_in?
  end

  def redirect_if_logged_out
    redirect_to new_session_url unless logged_in?
  end

  def redirect_unless_admin
    redirect_to root_url unless admin?
  end

  def redirect_if_picks_closed
    if Round.where("picks_end > ?", DateTime.now)
            .where("picks_start < ?", DateTime.now)
            .none?
      flash[:errors] = ["Picks are closed!"]
      redirect_to scoreboard_users_url
    end
  end
end
