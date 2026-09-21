# frozen_string_literal: true

# Representa uma empresa (Tenant) no sistema FleetMaster.
# É a entidade central para o isolamento de dados (Multi-Tenancy).
class Company < ApplicationRecord
  PLANS = %w[starter pro enterprise].freeze
  BILLING_CYCLES = %w[monthly annual].freeze
  SUBSCRIPTION_STATUSES = %w[trialing active canceled].freeze

  has_many :users, dependent: :destroy
  has_many :drivers, dependent: :destroy
  has_many :vehicles, dependent: :destroy
  has_many :trips, dependent: :destroy

  validates :name, :cnpj, presence: true
  validates :cnpj, uniqueness: true
  validates :plan, inclusion: { in: PLANS }
  validates :billing_cycle, inclusion: { in: BILLING_CYCLES }
  validates :subscription_status, inclusion: { in: SUBSCRIPTION_STATUSES }
  validate :cnpj_must_be_valid

  before_create :set_trial_period

  # Retorna o nome amigável do plano contratado.
  #
  # @return [String]
  def plan_name_human
    case plan
    when 'pro'
      'Professional'
    when 'enterprise'
      'Enterprise'
    else
      'Starter'
    end
  end

  # Retorna a tabela de limites conforme o plano da empresa.
  #
  # @return [Hash]
  def plan_limits
    case plan
    when 'pro'
      { max_users: 10, max_drivers: 20, max_vehicles: 20 }
    when 'enterprise'
      { max_users: Float::INFINITY, max_drivers: Float::INFINITY, max_vehicles: Float::INFINITY }
    else
      { max_users: 3, max_drivers: 5, max_vehicles: 5 }
    end
  end

  # Verifica se a empresa pode adicionar mais usuários web.
  #
  # @return [Boolean]
  def can_add_user?
    users.count < plan_limits[:max_users]
  end

  # Verifica se a empresa pode adicionar mais motoristas.
  #
  # @return [Boolean]
  def can_add_driver?
    drivers.count < plan_limits[:max_drivers]
  end

  # Verifica se a empresa pode adicionar mais veículos na frota.
  #
  # @return [Boolean]
  def can_add_vehicle?
    vehicles.count < plan_limits[:max_vehicles]
  end

  # Calcula os dias restantes de teste grátis.
  #
  # @return [Integer]
  def trial_days_remaining
    return 0 unless trial_ends_at.present? && subscription_status == 'trialing'

    days = ((trial_ends_at - Time.current) / 1.day).ceil
    [days, 0].max
  end

  private

  # Define o período de 14 dias de teste grátis se for uma nova empresa.
  #
  # @return [void]
  def set_trial_period
    self.trial_ends_at ||= 14.days.from_now
  end

  # Valida se o CNPJ fornecido é válido utilizando a gem CPF_CNPJ.
  #
  # @return [void]
  def cnpj_must_be_valid
    return if CNPJ.valid?(cnpj)

    errors.add(:cnpj, 'não é válido')
  end
end
