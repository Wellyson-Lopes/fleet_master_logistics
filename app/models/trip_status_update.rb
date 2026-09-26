# frozen_string_literal: true

# Representa uma ocorrência ou histórico de alteração de status em uma viagem pelo motorista.
# Permite registrar fotos (ActiveStorage) de entregas, notas ou incidentes (acidentes, quebras, etc.).
class TripStatusUpdate < ApplicationRecord
  include TenantScoped

  REASONS = %w[acidente quebra falta_combustivel cliente_ausente atraso_transito outro].freeze

  belongs_to :trip
  belongs_to :driver
  has_many_attached :photos

  validates :status, presence: true
  validates :reason, inclusion: { in: REASONS }, allow_blank: true

  scope :recent, -> { order(created_at: :desc) }

  def reason_human
    case reason
    when 'acidente' then 'Acidente de Trânsito'
    when 'quebra' then 'Falha Mecânica / Quebra'
    when 'falta_combustivel' then 'Falta de Combustível'
    when 'cliente_ausente' then 'Cliente Ausente no Local'
    when 'atraso_transito' then 'Congestionamento / Bloqueio de Via'
    when 'outro' then 'Outro Motivo'
    else reason
    end
  end
end
