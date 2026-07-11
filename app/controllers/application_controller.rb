# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authorizable

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_tenant
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from JWT::DecodeError, JWT::VerificationError, JWT::Base64DecodeError do |e|
    Rails.logger.warn("Erro de decodificação JWT: #{e.message}")
    render json: ApiErrorFormatter.format(:unauthorized, 'Token inválido ou expirado.'),
           status: :unauthorized
  end

  protected

  def set_current_tenant
    # Pula definição de tenant nas rotas de autenticação, pois o driver/motorista
    # ainda não está autenticado e o default_scope do TenantScoped retornaria none,
    # impedindo login e aceite de convite.
    return if login_or_invitation_path?

    if user_signed_in?
      Current.user = current_user
      Current.company = current_user.company
    # current_driver.present? dispara autenticação JWT lazy (diferente de
    # driver_signed_in? que é apenas verificação passiva). Isso garante que o
    # tenant seja definido mesmo quando authenticate_driver! ainda não rodou,
    # permitindo que o default_scope do TenantScoped funcione corretamente.
    elsif current_driver.present?
      Current.user = current_driver
      Current.company = current_driver.company
    end
  end

  def login_or_invitation_path?
    %w[/api/v1/drivers/login /api/v1/drivers/invitation/accept].include?(request.path)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name cnpj company_name company_logo])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name cnpj company_name company_logo])
    devise_parameter_sanitizer.permit(:invite, keys: %i[name cnpj])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[name cpf cnh cnpj])
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Driver) && request.format.html?
      sign_out(resource)
      drivers_welcome_path
    else
      stored_location_for(resource) || dashboard_index_path
    end
  end

  def after_accept_path_for(resource)
    if resource.is_a?(Driver) && request.format.html?
      sign_out(resource)
      drivers_welcome_path
    else
      super
    end
  end
end
