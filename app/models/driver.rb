# frozen_string_literal: true

# Representa um motorista no sistema FleetMaster.
# Motoristas entram no sistema através de um fluxo de convite enviado por administradores.
class Driver < ApplicationRecord
  # Configurações do Devise para Drivers:
  devise :invitable, :database_authenticatable, :recoverable,
         :rememberable, :validatable, :trackable

  # Anexos
  has_one_attached :avatar

  # Validações de presença (Nome é obrigatório apenas quando a conta está ativa/aceita)
  validates :name, presence: true, on: :update, if: :invitation_accepted_at?
  validates :cnpj, presence: true

  # Unicidade de documentos
  validates :cpf, :cnh, uniqueness: true, allow_blank: true

  # Validações de formato
  validate :cpf_must_be_valid, if: -> { cpf.present? }
  validate :cnpj_must_be_valid, if: -> { cnpj.present? }

  private

  def cpf_must_be_valid
    return if CPF.valid?(cpf)

    errors.add(:cpf, 'não é válido')
  end

  def cnpj_must_be_valid
    return if CNPJ.valid?(cnpj)

    errors.add(:cnpj, 'não é válido')
  end
end
