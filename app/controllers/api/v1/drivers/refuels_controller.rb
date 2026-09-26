# frozen_string_literal: true

module Api
  module V1
    module Drivers
      class RefuelsController < ApplicationController
        before_action :authenticate_driver!
        skip_before_action :authorize_action!

        def create
          vehicle = current_driver.current_vehicle || current_driver.company.vehicles.find_by(id: refuel_params[:vehicle_id])

          if vehicle.nil?
            render json: { error: 'Nenhum veículo atribuído ao motorista.' }, status: :unprocessable_entity
            return
          end

          refuel = current_driver.fuel_refuels.new(
            company_id: current_driver.company_id,
            vehicle_id: vehicle.id,
            current_mileage_km: refuel_params[:current_mileage_km],
            liters: refuel_params[:liters],
            total_amount: refuel_params[:total_amount],
            fuel_type: refuel_params[:fuel_type] || 'diesel_s10',
            notes: refuel_params[:notes]
          )

          refuel.receipt_photo.attach(refuel_params[:receipt_photo]) if refuel_params[:receipt_photo].present?

          if refuel.save
            # Atualiza a quilometragem atual do caminhão se informada maior
            if refuel.current_mileage_km.to_i > vehicle.current_mileage_km.to_i
              vehicle.update_column(:current_mileage_km, refuel.current_mileage_km.to_i)
            end

            # Cria notificação para o painel web da empresa
            current_driver.company.notifications.create!(
              title: "⛽ Novo Abastecimento: #{vehicle.plate}",
              message: "O motorista #{current_driver.name} registrou #{refuel.liters}L de #{refuel.fuel_type_human} (R$ #{refuel.total_amount}) para o veículo #{vehicle.plate}.",
              notification_type: 'fuel_refuel',
              notifiable: refuel
            )

            render json: {
              status: { code: 201, message: 'Abastecimento registrado com sucesso!' },
              data: {
                id: refuel.id,
                vehicle_plate: vehicle.plate,
                liters: refuel.liters.to_f,
                total_amount: refuel.total_amount.to_f,
                fuel_type: refuel.fuel_type,
                current_mileage_km: refuel.current_mileage_km,
                created_at: refuel.created_at
              }
            }, status: :created
          else
            render json: { error: refuel.errors.full_messages.join(', ') }, status: :unprocessable_entity
          end
        end

        private

        def refuel_params
          params.require(:refuel).permit(
            :vehicle_id,
            :current_mileage_km,
            :liters,
            :total_amount,
            :fuel_type,
            :notes,
            :receipt_photo
          )
        end
      end
    end
  end
end
