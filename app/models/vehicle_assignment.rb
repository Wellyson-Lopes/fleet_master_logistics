# frozen_string_literal: true

# Representa a atribuição de um veículo a um motorista por um período.
# Permite que diferentes motoristas dirijam o mesmo veículo em dias
# diferentes, e que um motorista dirija diferentes veículos ao longo do tempo.
class VehicleAssignment < ApplicationRecord
  belongs_to :vehicle
  belongs_to :driver

  validates :assigned_at, presence: true
  validate :vehicle_and_driver_must_be_same_company

  scope :current, -> { where(unassigned_at: nil) }
  scope :for_date, ->(date) { where(assigned_at: ..date.end_of_day, unassigned_at: [nil, date.end_of_day..]) }

  private

  # Garante integridade multi-tenant: veículo e motorista devem pertencer
  # à mesma empresa.
  def vehicle_and_driver_must_be_same_company
    return unless vehicle && driver && vehicle.company_id != driver.company_id

    errors.add(:driver, 'não pertence à mesma empresa do veículo')
  end
end
