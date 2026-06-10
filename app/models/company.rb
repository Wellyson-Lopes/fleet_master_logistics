# frozen_string_literal: true

# Representa uma empresa (Tenant) no sistema FleetMaster.
# É a entidade central para o isolamento de dados (Multi-Tenancy).
class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :drivers, dependent: :destroy

  validates :name, :cnpj, presence: true
  validates :cnpj, uniqueness: true
  validate :cnpj_must_be_valid

  private

  # Valida se o CNPJ fornecido é válido utilizando a gem CPF_CNPJ.
  #
  # @return [void]
  def cnpj_must_be_valid
    return if CNPJ.valid?(cnpj)

    errors.add(:cnpj, 'não é válido')
  end
end
