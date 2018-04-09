class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: :devise_controller?
protected
  def set_locale
    I18n.locale = locale_params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def locale_params
    params.permit(:locale)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:username, :email, :email_confirmation, :password, :password_confirmation)
    end
  end

  def user_not_authorized
    flash[:alert] = I18n.t 'not_authorized'
    redirect_to (request.referrer || root_path), status: :forbidden
  end
end
