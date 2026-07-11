# frozen_string_literal: true

FactoryBot.define do
  factory :company do
    name { 'Minha Empresa' }
    cnpj { CNPJ.generate }
  end
end
