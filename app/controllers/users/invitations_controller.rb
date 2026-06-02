# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    before_action :authenticate_inviter!, only: %i[new create]
    before_action :ensure_admin!, only: %i[new create]

    protected

    def ensure_admin!
      return if current_user&.admin?

      redirect_to dashboard_index_path, alert: 'Você não tem permissão para convidar novos usuários.'
    end
  end
end
