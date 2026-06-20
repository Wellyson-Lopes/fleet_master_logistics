# frozen_string_literal: true

module Api
  module V1
    module Drivers
      # Controller responsável pela gestão do perfil do motorista logado via API.
      # Permite a visualização e atualização de dados profissionais.
      class ProfilesController < ApplicationController
        before_action :authenticate_driver!
        respond_to :json

        # Retorna os dados do perfil do motorista autenticado.
        #
        # @example URL
        #   GET /api/v1/drivers/profile
        #
        # @return [void]
        def show
          render json: {
            status: { code: 200, message: 'Perfil carregado com sucesso.' },
            data: current_driver_data
          }, status: :ok
        end

        # Atualiza os dados do perfil do motorista autenticado.
        #
        # @example URL
        #   PATCH /api/v1/drivers/profile
        #
        # @return [void]
        def update
          if current_driver.update(driver_params)
            render_success('Perfil atualizado com sucesso!')
          else
            render_error('Erro ao atualizar perfil.', current_driver.errors.full_messages)
          end
        end

        private

        def render_success(message)
          render json: {
            status: { code: 200, message: message },
            data: current_driver_data
          }, status: :ok
        end

        def render_error(message, errors)
          render json: {
            status: { code: 422, message: message },
            errors: errors
          }, status: :unprocessable_entity
        end

        # Serializa os dados do motorista atual para JSON.
        #
        # @return [Hash] Dados do motorista
        def current_driver_data
          current_driver.as_json(only: %i[id email name cnpj cpf cnh active])
        end

        # Parâmetros permitidos para atualização de perfil.
        #
        # @return [ActionController::Parameters]
        def driver_params
          params.require(:driver).permit(:name, :cpf, :cnpj, :cnh)
        end
      end
    end
  end
end
