# frozen_string_literal: true

module Api
  module V1
    module Drivers
      # Controller responsável pela autenticação de motoristas via JWT.
      # Gerencia o ciclo de vida da sessão (Login/Logout) através da API.
      class SessionsController < Devise::SessionsController
        skip_before_action :verify_authenticity_token
        respond_to :json

        # Autentica um motorista e retorna seus dados.
        # O token JWT é enviado no header Authorization da resposta.
        #
        # @example URL
        #   POST /api/v1/drivers/login
        #
        # @return [void]
        def create
          sign_out(current_driver) if current_driver
          self.resource = find_driver

          if resource&.valid_password?(driver_params[:password])
            authenticate_and_respond
          else
            render_unauthorized
          end
        end

        private

        def driver_params
          params.require(:driver).permit(:email, :password)
        end

        def find_driver
          Driver.find_by(email: driver_params[:email])
        end

        def authenticate_and_respond
          sign_in(resource_name, resource)
          yield resource if block_given?
          respond_with(resource)
        end

        def render_unauthorized
          render json: ApiErrorFormatter.format(:unauthorized, 'E-mail ou senha inválidos.'),
                 status: :unauthorized
        end

        # Customiza a resposta JSON após a tentativa de login.
        #
        # @param resource [Driver] O motorista que tentou se autenticar
        # @param _opts [Hash] Opções adicionais do Devise
        #
        # @return [void]
        def respond_with(resource, _opts = {})
          if resource.persisted?
            render json: {
              status: { code: 200, message: 'Logado com sucesso.' },
              data: resource.as_json(only: %i[id email name cnpj cpf cnh active])
            }, status: :ok
          else
            render_unauthorized
          end
        end

        # Customiza a resposta JSON após o logout.
        #
        # @param _args [Array] Argumentos capturados pelo splat
        #
        # @return [void]
        def respond_to_on_destroy(*_args)
          # Logout com JWT é processado pela estratégia de revogação.
          # Aqui apenas garantimos a resposta JSON.
          render json: {
            status: { code: 200, message: 'Logout realizado com sucesso ou sessão encerrada.' }
          }, status: :ok
        end
      end
    end
  end
end
