# frozen_string_literal: true

# Policy específica para o modelo Driver.
# Controla o acesso a dados de motoristas garantindo isolamento multi-tenant.
# Motoristas só podem acessar seus próprios dados.
# Administradores podem gerenciar motoristas da mesma empresa.
class DriverPolicy < ApplicationPolicy
  # Verifica se o usuário pode listar motoristas.
  # Motoristas NÃO podem listar outros motoristas.
  # Admins podem listar motoristas da empresa.
  #
  # @return [Boolean]
  def index?
    admin?
  end

  # Verifica se o usuário pode visualizar um motorista.
  # Motoristas só podem ver seu próprio perfil.
  # Admins podem ver qualquer motorista da empresa.
  #
  # @return [Boolean]
  def show?
    owner_of_record? || (admin? && same_company?)
  end

  # Verifica se o usuário pode criar motoristas.
  # Apenas admins podem criar motoristas (via convite).
  #
  # @return [Boolean]
  def create?
    admin?
  end

  # Verifica se o usuário pode atualizar um motorista.
  # Motoristas só podem editar seu próprio perfil.
  # Admins podem editar qualquer um da empresa.
  #
  # @return [Boolean]
  def update?
    owner_of_record? || (admin? && same_company?)
  end

  # Verifica se o usuário pode remover um motorista.
  # Apenas admins podem remover motoristas da mesma empresa.
  #
  # @return [Boolean]
  def destroy?
    admin? && same_company?
  end

  # Escopo para listagens de motoristas.
  # Admins veem motoristas da empresa; motoristas não veem ninguém.
  class Scope < ApplicationPolicy::Scope
    # Resolve o escopo retornando motoristas da empresa do usuário.
    # Motoristas sem acesso a index não devem usar este scope.
    #
    # @return [ActiveRecord::Relation] Motoristas da empresa
    def resolve
      return scope.none unless user.respond_to?(:admin?) && user.admin?

      scope.where(company_id: user.company_id)
    end
  end
end
