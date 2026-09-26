# frozen_string_literal: true

class AsaasChargePolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present? && (record.nil? || same_company?)
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless user.respond_to?(:company_id)

      scope.where(company_id: user.company_id)
    end
  end
end
