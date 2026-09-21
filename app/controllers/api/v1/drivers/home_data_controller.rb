# frozen_string_literal: true

module Api
  module V1
    module Drivers
      class HomeDataController < ApplicationController
        before_action :authenticate_driver!

        def show
          driver = current_driver
          vehicle = driver.current_vehicle
          active_trip = driver.trips.where(status: %w[in_transit scheduled delayed]).order(created_at: :desc).first

          render json: {
            driver: {
              id: driver.id,
              name: driver.name,
              email: driver.email,
              cpf: driver.cpf,
              cnh: driver.cnh
            },
            assigned_vehicle: vehicle ? {
              id: vehicle.id,
              plate: vehicle.plate,
              type: vehicle.type,
              brand: vehicle.brand,
              model: vehicle.model,
              status: vehicle.status
            } : nil,
            active_trip: active_trip ? {
              id: active_trip.id,
              code: active_trip.code,
              origin: active_trip.origin,
              destination: active_trip.destination,
              client_name: active_trip.client_name,
              cargo_description: active_trip.cargo_description,
              cargo_weight_kg: active_trip.cargo_weight_kg,
              status: active_trip.status,
              status_human: active_trip.status_human,
              distance_km: active_trip.distance_km
            } : nil,
            company: {
              name: driver.company.name,
              cnpj: driver.company.cnpj
            }
          }
        end
      end
    end
  end
end
