# frozen_string_literal: true

# Representa uma notificação enviada para o aplicativo do motorista
# (nova viagem, CNH vencida, documento do veículo, etc.).
class DriverNotification < ApplicationRecord
  include TenantScoped

  TYPES = %w[trip_assigned trip_accepted new_trip trip_status_change cnh_expired cnh_expiring_soon vehicle_alert system
             welcome].freeze

  belongs_to :driver
  belongs_to :notifiable, polymorphic: true, optional: true

  validates :title, :message, presence: true
  validates :notification_type, inclusion: { in: TYPES }

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc) }

  def mark_as_read!
    update(read: true, read_at: Time.current) unless read?
  end

  def icon_name
    case notification_type
    when 'trip_assigned', 'trip_status_change' then 'truck'
    when 'cnh_expired', 'cnh_expiring_soon' then 'alert-triangle'
    when 'vehicle_alert' then 'tool'
    else 'bell'
    end
  end
end
