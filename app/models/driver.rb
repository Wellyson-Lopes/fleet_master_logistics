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

  # Atribuição de veículos (relação many-to-many com datas)
  has_many :vehicle_assignments, dependent: :destroy
  has_many :vehicles, through: :vehicle_assignments

  # Herda dados da empresa do usuário que enviou o convite
  before_validation :inherit_company_data, if: :invitation_token?

  # Validações de presença (Nome é obrigatório apenas quando a conta está ativa/aceita)
  validates :name, presence: true, on: :update, if: :invitation_accepted_at?
  validates :cnpj, presence: true

  # Unicidade de documentos
  validates :cpf, :cnh, uniqueness: { case_sensitive: false }, allow_blank: true

  # Validações de formato
  validate :cpf_must_be_valid, if: -> { cpf.present? }
  validate :cnpj_must_be_valid, if: -> { cnpj.present? }

  # Valida que o CNPJ do motorista seja o mesmo da empresa vinculada
  validate :cnpj_matches_company, if: -> { company.present? && cnpj.present? }

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

  # Valida se o CNPJ do motorista corresponde ao CNPJ da empresa vinculada.
  # Garante integridade dos dados no isolamento multi-tenant.
  #
  # @return [void]
  def cnpj_matches_company
    return if cnpj == company.cnpj

    errors.add(:cnpj, 'não corresponde ao CNPJ da empresa')
  end

  # Herda company_id e cnpj do usuário que enviou o convite.
  # Garante que o motorista seja sempre vinculado à empresa correta.
  #
  # @return [void]
  def inherit_company_data
    return unless invited_by

    self.company = invited_by.company
    self.cnpj = invited_by.cnpj
  end
end
