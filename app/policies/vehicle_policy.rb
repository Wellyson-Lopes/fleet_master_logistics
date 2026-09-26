# frozen_string_literal: true

class VehiclePolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin? && same_company?
  end

  def create?
    admin?
  end

  def update?
    admin? && same_company?
  end

  def destroy?
    admin? && same_company?
  end

  def assign_driver?
    admin? && same_company?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless user.respond_to?(:admin?) && user.admin?

      scope.where(company_id: user.company_id)
    end
  end
end
