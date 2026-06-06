# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def index
    @users = current_user.company_users # Assuming there's a scope or method for this
    @invitation_user = User.new
  end

  private

  def ensure_admin!
    return if current_user.admin?

    redirect_to dashboard_index_path, alert: 'Acesso negado. Apenas administradores podem gerenciar a equipe.'
  end
end
