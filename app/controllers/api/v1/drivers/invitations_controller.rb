# frozen_string_literal: true

module Api
  module V1
    module Drivers
      # Controller responsável pelo processamento de convites de motoristas via API.
      # Permite que o motorista aceite o convite e defina sua senha inicial.
      class InvitationsController < DeviseController
        skip_before_action :verify_authenticity_token
        respond_to :json

        # Aceita um convite e ativa a conta do motorista.
        #
        # @example URL
        #   POST /api/v1/drivers/invitation/accept
        #
        # @return [void]
        def accept
          resource = Driver.accept_invitation!(accept_invitation_params)

          if resource.errors.empty?
            render_success(resource)
          else
            render_error(resource)
          end
        end

        private

        # Renderiza resposta de sucesso após aceite de convite.
        #
        # @param resource [Driver] O motorista que aceitou o convite
        #
        # @return [void]
        def render_success(resource)
          sign_in(:driver, resource)
          render json: {
            status: { code: 200, message: 'Cadastro finalizado com sucesso!' },
            data: resource.as_json(only: %i[id email name cnpj cpf cnh active])
          }, status: :ok
        end

        # Renderiza resposta de erro caso o convite falhe.
        #
        # @param resource [Driver] O motorista com erros de validação
        #
        # @return [void]
        def render_error(resource)
          render json: ApiErrorFormatter.format(:unprocessable_entity, 'Erro ao processar convite.', resource.errors),
                 status: :unprocessable_entity
        end

        # Parâmetros permitidos para aceite de convite.
        #
        # @return [ActionController::Parameters]
        def accept_invitation_params
          params.require(:driver).permit(
            :invitation_token,
            :password,
            :password_confirmation,
            :name,
            :cpf,
            :cnpj,
            :cnh
          )
        end
      end
    end
  end
end
