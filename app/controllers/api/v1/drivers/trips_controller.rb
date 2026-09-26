# frozen_string_literal: true

module Api
  module V1
    module Drivers
      # Controller responsável pelas viagens do motorista autenticado.
      # Todos os endpoints são estritamente isolados ao `current_driver`.
      class TripsController < ApplicationController
        before_action :authenticate_driver!
        skip_before_action :authorize_action!
        before_action :set_trip, only: %i[show update_status accept]

        # Lista viagens do motorista.
        # Parâmetro opcional `status`:
        # - 'active': agendadas, em trânsito ou atrasadas
        # - 'history': entregues ou canceladas
        def index
          trips = current_driver.trips.includes(:vehicle).order(created_at: :desc)

          case params[:status]
          when 'active'
            trips = trips.where(status: %w[scheduled accepted in_transit delayed])
          when 'history'
            trips = trips.where(status: %w[delivered canceled not_delivered])
          end

          render json: {
            trips: trips.map { |t| serialize_trip(t) }
          }
        end

        def show
          render json: { trip: serialize_trip(@trip) }
        end

        # Histórico consolidado de entregas com totais do motorista.
        def history
          trips = current_driver.trips.where(status: 'delivered').includes(:vehicle).order(delivered_at: :desc)

          render json: {
            summary: {
              total_delivered_count: trips.count,
              total_cargo_weight_ton: (trips.sum(:cargo_weight_kg) / 1000.0).round(1),
              total_distance_km: trips.sum(:distance_km) || 0,
              total_freight_value: trips.sum(:freight_value).to_f
            },
            trips: trips.map { |t| serialize_trip(t) }
          }
        end

        # Aceita uma viagem atribuída ao motorista
        def accept
          if @trip.update(status: 'accepted')
            current_driver.driver_notifications.create(
              company_id: current_driver.company_id,
              title: "Viagem #{@trip.code} aceita",
              message: "Você confirmou o aceite da viagem para #{@trip.destination}.",
              notification_type: 'trip_accepted',
              notifiable: @trip
            )

            current_driver.company.notifications.create(
              title: "Viagem Aceita: #{@trip.code}",
              message: "O motorista #{current_driver.name} aceitou a viagem para #{@trip.destination}.",
              notification_type: 'trip_status',
              notifiable: @trip
            )

            render json: {
              message: 'Viagem aceita com sucesso!',
              trip: serialize_trip(@trip)
            }
          else
            render json: { error: @trip.errors.full_messages.join(', ') }, status: :unprocessable_entity
          end
        end

        def update_status
          new_status = params[:status]

          if Trip::STATUSES.include?(new_status)
            update_attrs = { status: new_status }

            case new_status
            when 'in_transit'
              update_attrs[:started_at] ||= Time.current
            when 'delivered'
              update_attrs[:delivered_at] ||= Time.current
            when 'not_delivered'
              update_attrs[:status_reason] = params[:reason] if params[:reason].present?
            end

            if @trip.update(update_attrs)
              # Registra a ocorrência/histórico
              update_record = @trip.trip_status_updates.create(
                company_id: current_driver.company_id,
                driver_id: current_driver.id,
                status: new_status,
                reason: params[:reason],
                notes: params[:notes],
                latitude: params[:latitude] || current_driver.current_latitude,
                longitude: params[:longitude] || current_driver.current_longitude
              )

              if params[:photos].present? && update_record.persisted?
                Array(params[:photos]).each do |photo|
                  update_record.photos.attach(photo)
                end
              end

              # Notificação no painel web caso haja incidente / não entrega
              if %w[not_delivered delayed].include?(new_status) || params[:reason].present?
                current_driver.company.notifications.create(
                  title: "⚠️ Incidente na Viagem #{@trip.code}",
                  message: "Motorista #{current_driver.name} reportou #{update_record.reason_human || new_status}: #{params[:notes]}",
                  notification_type: 'incident',
                  notifiable: @trip
                )
              end

              # Cria notificação para o motorista confirmando a alteração
              current_driver.driver_notifications.create(
                company_id: current_driver.company_id,
                title: "Viagem #{@trip.code}: #{@trip.status_human}",
                message: "O status da entrega para #{@trip.destination} foi atualizado para #{@trip.status_human}.",
                notification_type: 'trip_status_change',
                notifiable: @trip
              )

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
          last_loc = t.driver_locations.order(recorded_at: :desc).first

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
            last_location: last_loc ? {
              latitude: last_loc.latitude,
              longitude: last_loc.longitude,
              recorded_at: last_loc.recorded_at
            } : nil,
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
