# frozen_string_literal: true

class NotificationPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def read?
    user.present? && record.company_id == user.company_id
  end

  def read_all?
    user.present?
  end

  class Scope < Scope
    def resolve
      scope.where(company_id: user.company_id)
    end
  end
end
