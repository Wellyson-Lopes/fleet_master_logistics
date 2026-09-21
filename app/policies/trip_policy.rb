# frozen_string_literal: true

# Controla as permissões de acesso às viagens e rotas de entrega.
# Administradores gerenciam todas as viagens da empresa.
# Motoristas podem visualizar e atualizar suas próprias viagens.
class TripPolicy < ApplicationPolicy
  def index?
    admin? || user.is_a?(Driver)
  end

  def show?
    (admin? && same_company?) || driver_owner?
  end

  def create?
    admin?
  end

  def new?
    create?
  end

  def update?
    (admin? && same_company?) || driver_owner?
  end

  def edit?
    admin? && same_company?
  end

  def destroy?
    admin? && same_company?
  end

  def update_status?
    (admin? && same_company?) || driver_owner?
  end

  private

  def driver_owner?
    user.is_a?(Driver) && record.respond_to?(:driver_id) && record.driver_id == user.id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.respond_to?(:admin?) && user.admin?
        scope.where(company_id: user.company_id)
      elsif user.is_a?(Driver)
        scope.where(driver_id: user.id)
      else
        scope.none
      end
    end
  end
end
