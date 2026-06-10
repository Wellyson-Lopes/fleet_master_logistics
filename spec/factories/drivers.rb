# frozen_string_literal: true

FactoryBot.define do
  factory :driver do
    association :company
    email { 'motorista@exemplo.com' }
    password { 'senha123' }
    cnpj { association(:company).cnpj }
    cpf { CPF.generate }
    cnh { '12345678' }
    name { 'João da Silva' }
  end
end
