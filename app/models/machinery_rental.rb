# frozen_string_literal: true

# Representa um contrato / ordem de aluguel de máquinas pesadas.
class MachineryRental < ApplicationRecord
  include TenantScoped

  RENTAL_TYPES = %w[hourly daily].freeze
  STATUSES = %w[pending active completed canceled].freeze

  belongs_to :machinery
  belongs_to :client
  has_many :asaas_charges, as: :payable, dependent: :nullify

  before_validation :generate_rental_code, on: :create
  before_validation :calculate_rates_and_total

  validates :code, :rental_type, :start_date, presence: true
  validates :code, uniqueness: { scope: :company_id }
  validates :rental_type, inclusion: { in: RENTAL_TYPES }
  validates :status, inclusion: { in: STATUSES }
  validates :duration, numericality: { greater_than: 0 }
  validates :rate_applied, :total_amount, numericality: { greater_than_or_equal_to: 0 }

  scope :recent, -> { order(created_at: :desc) }
  scope :active, -> { where(status: 'active') }
  scope :completed, -> { where(status: 'completed') }

  after_save :sync_machinery_status

  def rental_type_human
    rental_type == 'hourly' ? 'Por Hora' : 'Diária'
  end

  def status_human
    case status
    when 'pending' then 'Pendente'
    when 'active' then 'Em Andamento'
    when 'completed' then 'Finalizado'
    when 'canceled' then 'Cancelado'
    else status.titleize
    end
  end

  def status_badge_class
    case status
    when 'pending' then 'bg-amber-100 text-amber-800'
    when 'active' then 'bg-blue-100 text-blue-800'
    when 'completed' then 'bg-green-100 text-green-800'
    when 'canceled' then 'bg-gray-100 text-gray-800'
    else 'bg-gray-100 text-gray-800'
    end
  end

  private

  def generate_rental_code
    return if code.present?

    self.code = "MCH-#{SecureRandom.hex(3).upcase}"
  end

  def calculate_rates_and_total
    return unless machinery

    if rate_applied.to_f.zero?
      self.rate_applied = rental_type == 'hourly' ? machinery.hourly_rate : machinery.daily_rate
    end

    self.total_amount = (duration.to_f * rate_applied.to_f).round(2)
  end

  def sync_machinery_status
    case status
    when 'active'
      machinery.update(status: 'rented') if machinery.status == 'available'
    when 'completed', 'canceled'
      machinery.update(status: 'available') if machinery.status == 'rented'
    end
  end
end
