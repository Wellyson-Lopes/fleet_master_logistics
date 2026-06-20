# frozen_string_literal: true

# Policy base para o sistema de autorização do FleetMaster.
# Define o comportamento padrão para todas as policies do sistema.
# Utiliza o padrão de autorização por empresa (multi-tenant) garantindo
# que usuários só acessem dados da sua própria empresa.
class ApplicationPolicy
  attr_reader :user, :record

  # Inicializa a policy com o usuário atual e o registro alvo.
  #
  # @param user [User, Driver] O usuário ou motorista logado
  # @param record [ApplicationRecord, Class] O registro ou modelo a ser autorizado
  # @return [void]
  def initialize(user, record)
    @user = user
    @record = record
  end

  # Verifica se o usuário pode listar registros.
  #
  # @return [Boolean]
  def index?
    false
  end

  # Verifica se o usuário pode visualizar um registro específico.
  #
  # @return [Boolean]
  def show?
    false
  end

  # Verifica se o usuário pode criar novos registros.
  #
  # @return [Boolean]
  def create?
    false
  end

  # Verifica se o usuário pode acessar o formulário de criação.
  #
  # @return [Boolean]
  def new?
    create?
  end

  # Verifica se o usuário pode atualizar um registro.
  #
  # @return [Boolean]
  def update?
    false
  end

  # Verifica se o usuário pode acessar o formulário de edição.
  #
  # @return [Boolean]
  def edit?
    update?
  end

  # Verifica se o usuário pode remover um registro.
  #
  # @return [Boolean]
  def destroy?
    false
  end

  private

  # Verifica se o usuário atual é um administrador.
  #
  # @return [Boolean]
  def admin?
    user.respond_to?(:admin?) && user.admin?
  end

  # Verifica se o usuário e o registro pertencem à mesma empresa.
  # Retorna false se o registro for nil ou uma Classe.
  #
  # @return [Boolean]
  def same_company?
    return false unless record.respond_to?(:company_id)

    user.respond_to?(:company_id) && user.company_id == record.company_id
  end

  # Verifica se o usuário é o proprietário do registro.
  # Retorna false se o registro for nil ou uma Classe.
  #
  # @return [Boolean]
  def owner_of_record?
    return false unless record.respond_to?(:id)

    user.id == record.id
  end

  # Escopo base para listagens.
  # Filtra registros por company_id do usuário logado.
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.none
    end

    private

    attr_reader :user, :scope
  end
end
