# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    before_action :authenticate_inviter!, only: %i[new create]
    before_action :authorize_invitation!, only: %i[new create]

    private

    # Verifica se o usuário atual tem permissão para enviar convites.
    # Apenas administradores da empresa podem convidar novos usuários.
    #
    # @return [void]
    def authorize_invitation!
      return if UserPolicy.new(current_user, User).create?

      redirect_to dashboard_index_path, alert: 'Você não tem permissão para convidar novos usuários.'
    end
  end
end
