# frozen_string_literal: true

# Concern que fornece autorização baseada em policies para controllers.
# Integrado ao padrão de autorização do FleetMaster, garantindo que
# todas as ações sejam verificadas antes da execução.
module Authorizable
  extend ActiveSupport::Concern

  included do
    helper_method :policy, :policy_scope
    before_action :authorize_action!
  end

  private

  # Retorna a policy correspondente ao controller atual.
  #
  # @param record [ApplicationRecord, nil] O registro alvo (opcional)
  # @return [ApplicationPolicy] A policy para o controller e registro
  def policy(record = nil)
    record ||= load_record_for_policy
    policy_class_name = "#{controller_name.classify}Policy"
    return nil unless policy_class_name.safe_constantize

    policy_class_name.constantize.new(current_resource, record)
  end

  # Verifica se a ação atual é permitida pela policy.
  # Redireciona ou retorna 403 se não autorizado.
  # Pula autorização se não houver usuário logado ou policy não existe.
  #
  # @return [void]
  def authorize_action!
    return if skip_authorization?
    return unless current_resource

    current_policy = policy
    return unless current_policy

    return if current_policy.send("#{action_name}?")

    handle_unauthorized
  end

  # Retorna o recurso atual logado (User ou Driver).
  #
  # @return [User, Driver, nil] O recurso logado
  def current_resource
    if respond_to?(:current_driver, true) && current_driver
      current_driver
    elsif respond_to?(:current_user, true) && current_user
      current_user
    end
  end

  # Carrega o registro para a policy baseado no ID da rota.
  #
  # @return [ApplicationRecord, nil] O registro encontrado ou nil
  def load_record_for_policy
    return nil unless params[:id]

    controller_name.classify.constantize.find_by(id: params[:id])
  rescue NameError
    nil
  end

  # Carrega o registro para autorização.
  #
  # @return [ApplicationRecord, nil] O registro encontrado ou nil
  def load_record_for_authorization
    load_record_for_policy
  end

  # Verifica se a autorização deve ser pulada.
  # Override em controllers específicos se necessário.
  #
  # @return [Boolean]
  def skip_authorization?
    false
  end

  # Lida com usuários não autorizados.
  # Override em controllers específicos para comportamento customizado.
  #
  # @return [void]
  def handle_unauthorized
    respond_to do |format|
      format.html { redirect_to root_path, alert: 'Acesso não autorizado.' }
      format.json do
        render json: ApiErrorFormatter.format(:forbidden, 'Acesso não autorizado.'),
               status: :forbidden
      end
    end
  end

  # Retorna o escopo autorizado para um dado model.
  #
  # @param scope [Class] O modelo base (ex: User)
  # @return [ActiveRecord::Relation] Escopo filtrado
  def policy_scope(scope)
    policy_class_name = "#{scope.to_s.classify}Policy::Scope"
    policy_class_name.constantize.new(current_resource, scope).resolve
  end
end
