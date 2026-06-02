# frozen_string_literal: true

class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :company_logo

  before_validation :inherit_company_data, if: :invited?
  before_create :set_default_admin, if: :owner?

  validates :name, :company_name, presence: true, if: :owner?
  validates :cnpj, uniqueness: true, allow_blank: true
  validate :cnpj_must_be_valid, if: -> { cnpj.present? }

  def owner?
    invited_by_id.nil?
  end

  def invited?
    invited_by_id.present?
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

    self.cnpj = invited_by.cnpj
    self.company_name = invited_by.company_name
  end

  def cnpj_present?
    cnpj.present?
  end
end
