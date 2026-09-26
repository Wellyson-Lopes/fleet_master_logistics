# frozen_string_literal: true

class ClientPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present? && same_company?
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    user.present? && (record.nil? || same_company?)
  end

  def edit?
    update?
  end

  def destroy?
    user.present? && (record.nil? || same_company?)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless user.respond_to?(:company_id)

      scope.where(company_id: user.company_id)
    end
  end
end
