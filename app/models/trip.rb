# frozen_string_literal: true

# Representa uma viagem / entrega logística de carga realizada por um caminhão da frota.
# Centraliza as informações de rota, cliente, valor do frete, materiais transportados e capacidade.
class Trip < ApplicationRecord
  include TenantScoped

  STATUSES = %w[scheduled in_transit delayed delivered canceled].freeze

  belongs_to :company
  belongs_to :vehicle
  belongs_to :driver

  before_validation :generate_trip_code, on: :create
  before_validation :sync_company_from_vehicle

  validates :code, :origin, :destination, :client_name, :cargo_description, presence: true
  validates :code, uniqueness: { scope: :company_id }
  validates :status, inclusion: { in: STATUSES }
  validates :cargo_weight_kg, numericality: { greater_than_or_equal_to: 0 }
  validates :freight_value, numericality: { greater_than_or_equal_to: 0 }
  validate :vehicle_and_driver_belong_to_same_company

  scope :recent, -> { order(created_at: :desc) }
  scope :in_transit, -> { where(status: 'in_transit') }
  scope :delivered, -> { where(status: 'delivered') }
  scope :scheduled, -> { where(status: 'scheduled') }

  # Calcula a porcentagem de ocupação da capacidade do veículo para esta viagem.
  #
  # @return [Float] Porcentagem de ocupação (0.0 a 100.0+)
  def capacity_occupancy_percentage
    return 0.0 unless vehicle&.load_capacity_kg&.positive?

    ((cargo_weight_kg.to_f / vehicle.load_capacity_kg) * 100).round(1)
  end

  # Indica se o peso da carga excede a capacidade homologada do caminhão.
  #
  # @return [Boolean]
  def overweight?
    return false unless vehicle&.load_capacity_kg&.positive?

    cargo_weight_kg > vehicle.load_capacity_kg
  end

  # Retorna o nome amigável do status da viagem.
  #
  # @return [String]
  def status_human
    case status
    when 'in_transit' then 'Em Trânsito'
    when 'delivered' then 'Entregue'
    when 'delayed' then 'Atrasada'
    when 'canceled' then 'Cancelada'
    else 'Agendada'
    end
  end

  # Retorna a classe CSS de cor do status.
  #
  # @return [String]
  def status_badge_class
    case status
    when 'in_transit' then 'bg-blue-100 text-blue-800'
    when 'delivered' then 'bg-green-100 text-green-800'
    when 'delayed' then 'bg-red-100 text-red-800'
    when 'canceled' then 'bg-gray-100 text-gray-800'
    else 'bg-amber-100 text-amber-800'
    end
  end

  private

  def generate_trip_code
    return if code.present?

    self.code = "TRP-#{SecureRandom.hex(3).upcase}"
  end

  def sync_company_from_vehicle
    self.company ||= vehicle&.company || driver&.company
  end

  def vehicle_and_driver_belong_to_same_company
    return unless vehicle && driver

    if vehicle.company_id != company_id || driver.company_id != company_id
      errors.add(:base, 'Veículo e motorista devem pertencer à mesma empresa.')
    end
  end
end
