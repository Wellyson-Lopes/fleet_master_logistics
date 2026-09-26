# frozen_string_literal: true

# Registra os abastecimentos da frota realizados pelos motoristas.
# Suporta foto da nota fiscal via ActiveStorage e armazena odômetro, litragem e valor pago.
class FuelRefuel < ApplicationRecord
  include TenantScoped

  FUEL_TYPES = %w[diesel_s10 diesel_s500 gasolina etanol arla32].freeze

  belongs_to :vehicle
  belongs_to :driver
  has_one_attached :receipt_photo

  validates :current_mileage_km, numericality: { greater_than: 0 }
  validates :liters, numericality: { greater_than: 0 }
  validates :total_amount, numericality: { greater_than: 0 }
  validates :fuel_type, inclusion: { in: FUEL_TYPES }

  scope :recent, -> { order(created_at: :desc) }

  def fuel_type_human
    case fuel_type
    when 'diesel_s10' then 'Diesel S-10'
    when 'diesel_s500' then 'Diesel S-500'
    when 'gasolina' then 'Gasolina Comum / Aditivada'
    when 'etanol' then 'Etanol'
    when 'arla32' then 'Arla 32'
    else fuel_type.to_s.titleize
    end
  end
end
