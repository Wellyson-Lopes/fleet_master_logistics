# frozen_string_literal: true

# Controla as permissões de acesso às viagens e rotas de entrega.
# Administradores gerenciam todas as viagens da empresa.
# Motoristas podem visualizar e atualizar suas próprias viagens.
class TripPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    same_company? || driver_owner?
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    same_company? || driver_owner?
  end

  def edit?
    same_company?
  end

  def destroy?
    admin? && same_company?
  end

  def update_status?
    same_company? || driver_owner?
  end

  private

  def driver_owner?
    user.is_a?(Driver) && record.respond_to?(:driver_id) && record.driver_id == user.id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.is_a?(Driver)
        scope.where(driver_id: user.id)
      elsif user.respond_to?(:company_id) && user.company_id.present?
        scope.where(company_id: user.company_id)
      else
        scope.none
      end
    end
  end
end
