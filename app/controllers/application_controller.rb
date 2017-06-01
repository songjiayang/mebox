class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :should_login

  def js_class_name
    action = case action_name
    when 'create' then 'New'
    when 'update' then 'Edit'
    else action_name
    end.camelize
    "Views.#{self.class.name.gsub('::', '.').gsub(/Controller$/, '')}.#{action}View"
  end

  helper_method :js_class_name, :current_user_id

  protected

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def current_user_id
    session[:user_id]
  end

  def login?
    session[:user_id].present?
  end

  def sign_in(user_id)
    session[:user_id] = user_id
  end

  def should_login
    redirect_to new_sessions_path unless login?
  end

  def should_sign_out
    redirect_to root_path if login?
  end
end
