# frozen_string_literal: true

class ReportPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def print_pdf?
    user.present?
  end

  class Scope < Scope
    def resolve
      scope.where(company_id: user.company_id)
    end
  end
end
