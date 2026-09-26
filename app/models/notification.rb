# frozen_string_literal: true

# Representa uma notificação para o painel web de secretários e administradores da empresa.
# Alerta sobre novos incidentes reportados, viagens concluídas, documentos vencendo e abastecimentos.
class Notification < ApplicationRecord
  include TenantScoped

  TYPES = %w[incident trip_status document_expiring maintenance fuel_refuel system].freeze

  belongs_to :user, optional: true
  belongs_to :notifiable, polymorphic: true, optional: true

  validates :title, :message, :notification_type, presence: true
  validates :notification_type, inclusion: { in: TYPES }

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc) }

  def mark_as_read!
    update(read: true, read_at: Time.current)
  end
end
