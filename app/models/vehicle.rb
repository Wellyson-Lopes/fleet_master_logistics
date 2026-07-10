# frozen_string_literal: true

# Representa um veículo da frota (caminhão, trator, escavadeira, etc.)
# no sistema FleetMaster.
# Cada veículo pertence a uma empresa (multi-tenant) e pode ser atribuído
# a diferentes motoristas ao longo do tempo via VehicleAssignment.
class Vehicle < ApplicationRecord
  include TenantScoped

  # Desabilita STI (Single Table Inheritance) pois usamos type como campo livre
  self.inheritance_column = nil

  has_many :vehicle_assignments, dependent: :destroy
  has_many :drivers, through: :vehicle_assignments

  # Validações
  validates :type, presence: true
  validates :plate, presence: true, uniqueness: { case_sensitive: false }
  validates :load_capacity_kg, numericality: { greater_than: 0, allow_nil: true }
  validates :year, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1900,
    less_than_or_equal_to: ->(_) { Date.current.year + 1 },
    allow_nil: true
  }
  validates :status, inclusion: { in: %w[active maintenance inactive] }, allow_nil: true

  # Scopes
  scope :by_type, ->(type) { where(type: type) if type.present? }
  scope :active, -> { where(status: 'active') }
end
