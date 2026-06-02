# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name cnpj company_name company_logo])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name cnpj company_name company_logo])
    devise_parameter_sanitizer.permit(:invite, keys: [:name])
  end

  def after_sign_in_path_for(_resource)
    dashboard_index_path
  end
end
