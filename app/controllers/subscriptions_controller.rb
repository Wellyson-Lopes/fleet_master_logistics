# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company

  def index
    @company = current_user.company
    @limits = @company.plan_limits
    @vehicles_count = @company.vehicles.count
    @drivers_count = @company.drivers.count
    @users_count = @company.users.count
  end

  def update
    if @company.update(subscription_params)
      redirect_to subscriptions_path, notice: "Plano atualizado para #{@company.plan_name_human} com sucesso!"
    else
      redirect_to subscriptions_path,
                  alert: "Não foi possível atualizar o plano: #{@company.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_company
    @company = current_user.company
  end

  def subscription_params
    params.require(:company).permit(:plan, :billing_cycle)
  end
end
