# frozen_string_literal: true

FactoryBot.define do
  factory :driver do
    association :company
    email { "motorista_#{SecureRandom.hex(4)}@exemplo.com" }
    password { 'senha123' }
    cnpj { company.cnpj }
    cpf { CPF.generate }
    cnh { SecureRandom.random_number(10**10).to_s }
    name { 'João da Silva' }
  end
end
