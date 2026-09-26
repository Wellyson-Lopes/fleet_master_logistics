# frozen_string_literal: true

# Representa uma máquina ou equipamento pesado disponível para locação (escavadeiras, tratores, muncks, etc.).
class Machinery < ApplicationRecord
  include TenantScoped

  CATEGORIES = [
    'Escavadeira Hidráulica',
    'Retroescavadeira',
    'Pá Carregadeira',
    'Trator de Esteira',
    'Motoniveladora',
    'Caminhão Munck',
    'Guindaste',
    'Rolo Compactador',
    'Empilhadeira'
  ].freeze

  STATUSES = %w[available rented maintenance].freeze

  has_many :machinery_rentals, dependent: :restrict_with_error

  validates :name, :category, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :hourly_rate, :daily_rate, numericality: { greater_than_or_equal_to: 0 }

  scope :available, -> { where(status: 'available') }
  scope :rented, -> { where(status: 'rented') }
  scope :in_maintenance, -> { where(status: 'maintenance') }
  scope :recent, -> { order(created_at: :desc) }

  def available?
    status == 'available'
  end

  def status_human
    case status
    when 'available' then 'Disponível'
    when 'rented' then 'Alugada'
    when 'maintenance' then 'Em Manutenção'
    else status.titleize
    end
  end

  def status_badge_class
    case status
    when 'available' then 'bg-green-100 text-green-800'
    when 'rented' then 'bg-blue-100 text-blue-800'
    when 'maintenance' then 'bg-amber-100 text-amber-800'
    else 'bg-gray-100 text-gray-800'
    end
  end
end
