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
  has_one_attached :photo

  # Atribuição de veículos (relação many-to-many com datas)
  has_many :vehicle_assignments, dependent: :destroy
  has_many :vehicles, through: :vehicle_assignments
  has_many :trips, dependent: :destroy
  has_many :driver_locations, dependent: :destroy
  has_many :driver_notifications, dependent: :destroy
  has_many :trip_status_updates, dependent: :destroy
  has_many :fuel_refuels, dependent: :destroy

  # Gera um código numérico de 6 dígitos para o convite do motorista
  def generate_invitation_code!
    self.invitation_code = format('%06d', SecureRandom.random_number(1_000_000))
    self.invitation_code_sent_at = Time.current
    self.invitation_code_expires_at = 7.days.from_now
    save(validate: false)
    invitation_code
  end

  # Verifica se o código de 6 dígitos fornecido é válido e ainda não expirou (válido por 7 dias)
  def valid_invitation_code?(code)
    return false if invitation_code.blank? || code.blank?

    if invitation_code_expires_at.present?
      return false if invitation_code_expires_at < Time.current
    elsif invitation_code_sent_at.present?
      return false if invitation_code_sent_at < 7.days.ago
    end

    invitation_code.to_s.strip == code.to_s.strip
  end

  # Atualiza a localização em tempo real do motorista e registra o histórico
  def record_location!(latitude:, longitude:, speed: nil, heading: nil, trip_id: nil)
    update_columns(
      current_latitude: latitude,
      current_longitude: longitude,
      last_location_at: Time.current
    )

    driver_locations.create!(
      company_id: company_id,
      trip_id: trip_id,
      latitude: latitude,
      longitude: longitude,
      speed: speed,
      heading: heading,
      recorded_at: Time.current
    )
  end

  # Scopes
  scope :active, -> { where(active: true) }

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

  # Retorna a atribuição de veículo atualmente ativa.
  #
  # @return [VehicleAssignment, nil]
  def current_assignment
    vehicle_assignments.where(unassigned_at: nil).order(assigned_at: :desc).first
  end

  # Retorna o veículo atualmente alocado para o motorista.
  #
  # @return [Vehicle, nil]
  def current_vehicle
    current_assignment&.vehicle
  end

  # Verifica se a CNH está vencida.
  #
  # @return [Boolean]
  def cnh_expired?
    cnh_expiration.present? && cnh_expiration < Date.current
  end

  # Verifica se a CNH vai vencer nos próximos 30 dias.
  #
  # @return [Boolean]
  def cnh_expiring_soon?
    cnh_expiration.present? && cnh_expiration >= Date.current && cnh_expiration <= 30.days.from_now.to_date
  end

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
