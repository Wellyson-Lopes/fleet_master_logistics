# frozen_string_literal: true

# Representa um motorista no sistema FleetMaster.
# Motoristas entram no sistema através de um fluxo de convite enviado por administradores
# e utilizam prioritariamente o aplicativo móvel para sua operação logística.
class Driver < ApplicationRecord
  include TenantScoped

  # Configurações do Devise para Drivers:
  devise :invitable, :database_authenticatable, :recoverable,
         :rememberable, :validatable, :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

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

  # Valida se o CPF fornecido é válido utilizando a gem CPF_CNPJ.
  #
  # @return [void]
  def cpf_must_be_valid
    return if CPF.valid?(cpf)

    errors.add(:cpf, 'não é válido')
  end

  # Valida se o CNPJ fornecido é válido utilizando a gem CPF_CNPJ.
  #
  # @return [void]
  def cnpj_must_be_valid
    return if CNPJ.valid?(cnpj)

    errors.add(:cnpj, 'não é válido')
  end
end
