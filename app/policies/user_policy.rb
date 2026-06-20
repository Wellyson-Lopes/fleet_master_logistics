# frozen_string_literal: true

# Policy para o modelo User.
# Controla o acesso a dados de usuários garantindo isolamento multi-tenant.
# Usuários comuns podem ver dados da própria empresa.
# Administradores podem gerenciar todos os usuários da empresa.
class UserPolicy < ApplicationPolicy
  # Verifica se o usuário pode listar outros usuários.
  # Usuários comuns podem ver os dados da empresa.
  # Admins podem ver todos os usuários da empresa.
  #
  # @return [Boolean]
  def index?
    user.respond_to?(:company_id) && user.company_id.present?
  end

  # Verifica se o usuário pode visualizar um perfil.
  # Usuários podem ver seu próprio perfil e perfis da mesma empresa.
  # Admins podem ver qualquer um da empresa.
  #
  # @return [Boolean]
  def show?
    owner_of_record? || same_company?
  end

  # Verifica se o usuário pode criar usuários (via convite).
  # Apenas administradores podem convidar novos usuários.
  #
  # @return [Boolean]
  def create?
    admin?
  end

  # Verifica se o usuário pode atualizar um perfil.
  # Usuários podem editar seu próprio perfil.
  # Admins podem editar qualquer um da empresa.
  #
  # @return [Boolean]
  def update?
    owner_of_record? || (admin? && same_company?)
  end

  # Verifica se o usuário pode remover um usuário.
  # Apenas administradores podem remover usuários da mesma empresa.
  # Ninguém pode remover a si mesmo.
  #
  # @return [Boolean]
  def destroy?
    admin? && same_company? && !owner_of_record?
  end

  # Escopo para listagens de usuários.
  # Retorna apenas usuários da empresa do usuário logado.
  class Scope < Scope
    # Resolve o escopo retornando usuários da empresa do usuário.
    #
    # @return [ActiveRecord::Relation] Usuários da empresa
    def resolve
      if user.respond_to?(:company_id) && user.company_id.present?
        scope.where(company_id: user.company_id)
      else
        scope.none
      end
    end
  end
end
