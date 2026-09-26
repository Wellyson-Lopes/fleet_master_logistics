# frozen_string_literal: true

# Registra uma coordenada GPS transmitida pelo motorista durante suas viagens e rotas.
class DriverLocation < ApplicationRecord
  include TenantScoped

  belongs_to :driver
  belongs_to :trip, optional: true

  validates :latitude, :longitude, :recorded_at, presence: true

  scope :recent, -> { order(recorded_at: :desc) }
  scope :for_trip, ->(trip_id) { where(trip_id: trip_id).order(recorded_at: :asc) }
end
