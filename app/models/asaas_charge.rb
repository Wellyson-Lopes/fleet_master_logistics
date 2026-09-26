# frozen_string_literal: true

# Representa uma cobrança gerada via Asaas (PIX, Boleto ou Cartão de Crédito) para fretes, aluguel de máquinas ou planos.
class AsaasCharge < ApplicationRecord
  include TenantScoped

  BILLING_TYPES = %w[PIX BOLETO CREDIT_CARD].freeze
  STATUSES = %w[PENDING RECEIVED CONFIRMED OVERDUE REFUNDED].freeze

  belongs_to :client, optional: true
  belongs_to :payable, polymorphic: true, optional: true

  validates :billing_type, :value, :due_date, presence: true
  validates :billing_type, inclusion: { in: BILLING_TYPES }
  validates :status, inclusion: { in: STATUSES }
  validates :value, numericality: { greater_than: 0 }

  scope :recent, -> { order(created_at: :desc) }
  scope :pending, -> { where(status: 'PENDING') }
  scope :paid, -> { where(status: %w[RECEIVED CONFIRMED]) }

  def paid?
    %w[RECEIVED CONFIRMED].include?(status)
  end

  def status_human
    case status
    when 'PENDING' then 'Pendente'
    when 'RECEIVED' then 'Recebido'
    when 'CONFIRMED' then 'Confirmado'
    when 'OVERDUE' then 'Vencido'
    when 'REFUNDED' then 'Estornado'
    else status
    end
  end

  def status_badge_class
    case status
    when 'RECEIVED', 'CONFIRMED' then 'bg-green-100 text-green-800'
    when 'PENDING' then 'bg-amber-100 text-amber-800'
    when 'OVERDUE' then 'bg-red-100 text-red-800'
    else 'bg-gray-100 text-gray-800'
    end
  end
end
