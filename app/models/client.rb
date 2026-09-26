# frozen_string_literal: true

# Representa um cliente da transportadora ou contratante de fretes e aluguel de máquinas.
class Client < ApplicationRecord
  include TenantScoped

  has_many :machinery_rentals, dependent: :restrict_with_error
  has_many :asaas_charges, dependent: :nullify

  validates :name, presence: true
  validates :status, inclusion: { in: %w[active inactive] }

  scope :active, -> { where(status: 'active') }
  scope :recent, -> { order(created_at: :desc) }

  # Formata o documento para exibição limpa.
  def formatted_document
    return '-' if document.blank?

    clean = document.gsub(/\D/, '')
    if clean.length == 11
      "#{clean[0..2]}.#{clean[3..5]}.#{clean[6..8]}-#{clean[9..10]}"
    elsif clean.length == 14
      "#{clean[0..1]}.#{clean[2..4]}.#{clean[5..7]}/#{clean[8..11]}-#{clean[12..13]}"
    else
      document
    end
  end
end
