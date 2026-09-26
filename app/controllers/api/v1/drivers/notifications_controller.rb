# frozen_string_literal: true

module Api
  module V1
    module Drivers
      # Controller responsável por listar e marcar como lidas as notificações do motorista.
      class NotificationsController < ApplicationController
        before_action :authenticate_driver!
        skip_before_action :authorize_action!
        before_action :set_notification, only: [:read]

        # Lista as notificações do motorista autenticado.
        def index
          notifications = current_driver.driver_notifications.recent

          render json: {
            unread_count: notifications.unread.count,
            notifications: notifications.map do |n|
              {
                id: n.id,
                title: n.title,
                message: n.message,
                notification_type: n.notification_type,
                icon_name: n.icon_name,
                read: n.read,
                read_at: n.read_at,
                created_at: n.created_at,
                notifiable_type: n.notifiable_type,
                notifiable_id: n.notifiable_id
              }
            end
          }, status: :ok
        end

        # Marca uma notificação específica como lida.
        def read
          @notification.mark_as_read!

          render json: {
            status: 'success',
            message: 'Notificação marcada como lida.',
            notification: {
              id: @notification.id,
              read: @notification.read,
              read_at: @notification.read_at
            }
          }, status: :ok
        end

        # Marca todas as notificações como lidas.
        def read_all
          current_driver.driver_notifications.unread.update_all(read: true, read_at: Time.current)

          render json: {
            status: 'success',
            message: 'Todas as notificações foram marcadas como lidas.'
          }, status: :ok
        end

        private

        def set_notification
          @notification = current_driver.driver_notifications.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Notificação não encontrada.' }, status: :not_found
        end
      end
    end
  end
end
