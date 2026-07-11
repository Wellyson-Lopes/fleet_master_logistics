# frozen_string_literal: true

class User < ApplicationRecord
  include TenantScoped

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :company_logo

  before_validation :inherit_company_data, if: :invited?
  before_validation :build_company_for_owner, on: :create, if: :owner?
  before_create :set_default_admin, if: :owner?

  validates :name, :company_name, :cnpj, presence: true, if: :owner?
  validate :cnpj_must_be_valid, if: -> { cnpj.present? }

  def owner?
    invited_by_id.nil?
  end

  def invited?
    invited_by_id.present?
  end

  def company_users
    company.users
  end

  private

  def set_default_admin
    self.admin = true
  end

  def cnpj_must_be_valid
    return if CNPJ.valid?(cnpj)

    errors.add(:cnpj, 'não é válido')
  end

  def inherit_company_data
    return unless invited_by

    self.company = invited_by.company
    self.cnpj = invited_by.cnpj
    self.company_name = invited_by.company_name
  end

  # Cria a Company automaticamente durante o cadastro do owner (sign-up).
  # Usa os dados de company_name e cnpj fornecidos no formulário de registro.
  #
  # @return [void]
  def build_company_for_owner
    return if company.present? || company_name.blank? || cnpj.blank?

    self.company = Company.new(name: company_name, cnpj: cnpj)
  end
end
