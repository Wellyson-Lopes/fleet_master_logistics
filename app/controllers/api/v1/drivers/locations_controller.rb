# frozen_string_literal: true

module Api
  module V1
    module Drivers
      # Controller responsável por receber coordenadas GPS e telemetria do motorista em tempo real.
      # Usado pelo app mobile para rastrear a rota do caminhão e calcular tempo estimado de entrega.
      class LocationsController < ApplicationController
        before_action :authenticate_driver!
        skip_before_action :authorize_action!

        # Registra a localização do motorista.
        #
        # @example URL
        #   POST /api/v1/drivers/location
        #   Body: { "location": { "latitude": -8.05, "longitude": -34.88, "speed": 60, "trip_id": "uuid" } }
        def create
          loc_params = params.require(:location).permit(:latitude, :longitude, :speed, :heading, :trip_id)

          trip = current_driver.trips.find_by(id: loc_params[:trip_id])

          location = current_driver.record_location!(
            latitude: loc_params[:latitude],
            longitude: loc_params[:longitude],
            speed: loc_params[:speed],
            heading: loc_params[:heading],
            trip_id: trip&.id
          )

          render json: {
            status: 'success',
            message: 'Localização registrada com sucesso.',
            data: {
              latitude: location.latitude.to_f,
              longitude: location.longitude.to_f,
              recorded_at: location.recorded_at,
              trip_code: trip&.code
            }
          }, status: :created
        rescue ActiveRecord::RecordInvalid => e
          render json: { error: e.record.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end
    end
  end
end
