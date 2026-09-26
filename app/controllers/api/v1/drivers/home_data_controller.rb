# frozen_string_literal: true

module Api
  module V1
    module Drivers
      # Controller responsável por agregar todos os dados da tela inicial do App do Motorista.
      # Retorna o perfil, veículo alocado, viagem ativa, estatísticas e contagem de notificações.
      class HomeDataController < ApplicationController
        before_action :authenticate_driver!
        skip_before_action :authorize_action!

        def show
          driver = current_driver
          vehicle = driver.current_vehicle
          active_trip = driver.trips.where(status: %w[in_transit scheduled delayed]).order(created_at: :desc).first
          completed_trips = driver.trips.where(status: 'delivered')

          render json: {
            driver: {
              id: driver.id,
              name: driver.name,
              email: driver.email,
              phone: driver.phone,
              cpf: driver.cpf,
              cnh: driver.cnh,
              cnh_expiration: driver.cnh_expiration,
              cnh_expired: driver.cnh_expired?,
              cnh_expiring_soon: driver.cnh_expiring_soon?,
              current_latitude: driver.current_latitude,
              current_longitude: driver.current_longitude,
              last_location_at: driver.last_location_at
            },
            assigned_vehicle: vehicle ? {
              id: vehicle.id,
              plate: vehicle.plate,
              type: vehicle.type,
              brand: vehicle.brand,
              model: vehicle.model,
              load_capacity_kg: vehicle.load_capacity_kg,
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
              freight_value: active_trip.freight_value.to_f,
              status: active_trip.status,
              status_human: active_trip.status_human,
              distance_km: active_trip.distance_km,
              started_at: active_trip.started_at,
              estimated_delivery_at: active_trip.estimated_delivery_at
            } : nil,
            stats: {
              completed_trips_count: completed_trips.count,
              total_delivered_ton: (completed_trips.sum(:cargo_weight_kg) / 1000.0).round(1),
              total_distance_km: completed_trips.sum(:distance_km) || 0
            },
            notifications: {
              unread_count: driver.driver_notifications.unread.count,
              recent: driver.driver_notifications.recent.limit(3).map do |n|
                {
                  id: n.id,
                  title: n.title,
                  message: n.message,
                  type: n.notification_type,
                  read: n.read,
                  created_at: n.created_at
                }
              end
            },
            company: {
              id: driver.company.id,
              name: driver.company.name,
              cnpj: driver.company.cnpj
            }
          }
        end
      end
    end
  end
end
