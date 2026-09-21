# frozen_string_literal: true

module Api
  module V1
    module Drivers
      class TripsController < ApplicationController
        before_action :authenticate_driver!
        skip_before_action :authorize_action!
        before_action :set_trip, only: %i[show update_status]

        def index
          trips = current_driver.trips.includes(:vehicle).order(created_at: :desc)
          render json: {
            trips: trips.map { |t| serialize_trip(t) }
          }
        end

        def show
          render json: { trip: serialize_trip(@trip) }
        end

        def update_status
          new_status = params[:status]

          if Trip::STATUSES.include?(new_status)
            case new_status
            when 'in_transit'
              @trip.started_at ||= Time.current
            when 'delivered'
              @trip.delivered_at ||= Time.current
            end

            if @trip.update(status: new_status)
              render json: {
                message: "Status atualizado para #{@trip.status_human}.",
                trip: serialize_trip(@trip)
              }
            else
              render json: { error: @trip.errors.full_messages.join(', ') }, status: :unprocessable_entity
            end
          else
            render json: { error: 'Status inválido informado.' }, status: :unprocessable_entity
          end
        end

        private

        def set_trip
          @trip = current_driver.trips.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Viagem não encontrada.' }, status: :not_found
        end

        def serialize_trip(t)
          {
            id: t.id,
            code: t.code,
            origin: t.origin,
            destination: t.destination,
            client_name: t.client_name,
            cargo_description: t.cargo_description,
            cargo_weight_kg: t.cargo_weight_kg,
            freight_value: t.freight_value.to_f,
            distance_km: t.distance_km,
            status: t.status,
            status_human: t.status_human,
            capacity_occupancy: t.capacity_occupancy_percentage,
            overweight: t.overweight?,
            vehicle: {
              plate: t.vehicle.plate,
              type: t.vehicle.type,
              model: "#{t.vehicle.brand} #{t.vehicle.model}".strip,
              load_capacity_kg: t.vehicle.load_capacity_kg
            },
            started_at: t.started_at,
            delivered_at: t.delivered_at,
            estimated_delivery_at: t.estimated_delivery_at,
            notes: t.notes
          }
        end
      end
    end
  end
end
