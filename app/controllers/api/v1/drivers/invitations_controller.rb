# frozen_string_literal: true

module Api
  module V1
    module Drivers
      # Controller responsável pelo processamento de convites de motoristas via API.
      # Suporta o fluxo moderno de ativação por código de 6 dígitos enviado por e-mail,
      # permitindo verificação do código e criação de senha para o primeiro login.
      class InvitationsController < DeviseController
        skip_before_action :verify_authenticity_token
        respond_to :json

        # Valida o código de 6 dígitos recebido por e-mail pelo motorista.
        #
        # @example URL
        #   POST /api/v1/drivers/invitation/verify_code
        #   Body: { "driver": { "email": "motorista@empresa.com", "code": "123456" } }
        def verify_code
          email = driver_params[:email]&.downcase&.strip
          code = driver_params[:code]&.strip
          driver = Driver.find_by(email: email)

          if driver.nil?
            render json: ApiErrorFormatter.format(:not_found, 'Motorista não encontrado com o e-mail informado.'),
                   status: :not_found
            return
          end

          if driver.valid_invitation_code?(code)
            render json: {
              status: { code: 200, message: 'Código de acesso validado com sucesso!' },
              data: {
                id: driver.id,
                name: driver.name,
                email: driver.email,
                company_name: driver.company&.name
              }
            }, status: :ok
          else
            render json: ApiErrorFormatter.format(:unprocessable_content, 'Código de acesso inválido ou expirado.'),
                   status: :unprocessable_content
          end
        end

        # Define a senha do motorista utilizando o código de acesso de 6 dígitos validado.
        #
        # @example URL
        #   POST /api/v1/drivers/invitation/set_password
        def set_password
          email = driver_params[:email]&.downcase&.strip
          code = driver_params[:code]&.strip
          driver = Driver.find_by(email: email)

          if driver.nil?
            render json: ApiErrorFormatter.format(:not_found, 'Motorista não encontrado.'),
                   status: :not_found
            return
          end

          unless driver.valid_invitation_code?(code)
            render json: ApiErrorFormatter.format(:unprocessable_content, 'Código de acesso inválido ou expirado.'),
                   status: :unprocessable_content
            return
          end

          update_attributes = {
            password: driver_params[:password],
            password_confirmation: driver_params[:password_confirmation],
            invitation_accepted_at: Time.current,
            invitation_code: nil,
            active: true
          }

          update_attributes[:name] = driver_params[:name] if driver_params[:name].present?
          update_attributes[:cpf] = driver_params[:cpf] if driver_params[:cpf].present?
          update_attributes[:cnh] = driver_params[:cnh] if driver_params[:cnh].present?
          update_attributes[:cnh_expiration] = driver_params[:cnh_expiration] if driver_params[:cnh_expiration].present?

          if driver.update(update_attributes)
            render_success(driver)
          else
            render json: ApiErrorFormatter.format(:unprocessable_content, 'Erro ao definir senha.', driver.errors),
                   status: :unprocessable_content
          end
        end

        # Aceita um convite via token legada (compatibilidade com devise_invitable).
        #
        # @example URL
        #   POST /api/v1/drivers/invitation/accept
        def accept
          resource = Driver.accept_invitation!(accept_invitation_params)

          if resource.errors.empty?
            render_success(resource)
          else
            render_error(resource)
          end
        end

        private

        def render_success(resource)
          sign_in(:driver, resource)
          render json: {
            status: { code: 200, message: 'Cadastro finalizado com sucesso!' },
            data: resource.as_json(only: %i[id email name cnpj cpf cnh active])
          }, status: :ok
        end

        def render_error(resource)
          render json: ApiErrorFormatter.format(:unprocessable_content, 'Erro ao processar convite.', resource.errors),
                 status: :unprocessable_content
        end

        def driver_params
          params.require(:driver).permit(
            :email,
            :code,
            :password,
            :password_confirmation,
            :name,
            :cpf,
            :cnpj,
            :cnh,
            :cnh_expiration
          )
        end

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
