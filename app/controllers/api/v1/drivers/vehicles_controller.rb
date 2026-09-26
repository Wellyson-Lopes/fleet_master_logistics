# frozen_string_literal: true

module Api
  module V1
    module Drivers
      # Controller que expõe dados e especificações do veículo atribuído ao motorista autenticado.
      class VehiclesController < ApplicationController
        before_action :authenticate_driver!
        skip_before_action :authorize_action!

        def show
          vehicle = current_driver.current_vehicle

          if vehicle.nil?
            render json: {
              status: 'not_assigned',
              message: 'Nenhum veículo alocado para você no momento.',
              vehicle: nil
            }, status: :ok
            return
          end

          assignment = current_driver.current_assignment

          render json: {
            status: 'assigned',
            vehicle: {
              id: vehicle.id,
              plate: vehicle.plate,
              type: vehicle.type,
              brand: vehicle.brand,
              model: vehicle.model,
              year: vehicle.year,
              load_capacity_kg: vehicle.load_capacity_kg,
              current_mileage_km: vehicle.current_mileage_km,
              status: vehicle.status,
              chassis: vehicle.chassis,
              renavam: vehicle.renavam,
              assigned_at: assignment&.assigned_at
            }
          }, status: :ok
        end
      end
    end
  end
end
