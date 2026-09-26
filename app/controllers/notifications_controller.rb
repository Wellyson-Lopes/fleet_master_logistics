# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:read]

  def index
    @notifications = current_user.company.notifications.recent.limit(30)
    @unread_count = current_user.company.notifications.unread.count

    respond_to do |format|
      format.html
      format.json do
        render json: {
          unread_count: @unread_count,
          notifications: @notifications.map do |n|
            {
              id: n.id,
              title: n.title,
              message: n.message,
              notification_type: n.notification_type,
              read: n.read,
              created_at: n.created_at.strftime('%d/%m %H:%M')
            }
          end
        }
      end
    end
  end

  def read
    @notification.mark_as_read!

    respond_to do |format|
      format.html { redirect_back fallback_location: notifications_path }
      format.json { render json: { status: 'success' } }
    end
  end

  def read_all
    current_user.company.notifications.unread.update_all(read: true, read_at: Time.current)

    respond_to do |format|
      format.html do
        redirect_back fallback_location: notifications_path, notice: 'Todas as notificações foram marcadas como lidas.'
      end
      format.json { render json: { status: 'success' } }
    end
  end

  private

  def set_notification
    @notification = current_user.company.notifications.find(params[:id])
  end
end
