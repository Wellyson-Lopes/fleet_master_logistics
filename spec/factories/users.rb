# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    association :company
    email { "user_#{SecureRandom.hex(4)}@exemplo.com" }
    password { 'senha123' }
    name { "Usuário #{SecureRandom.hex(2)}" }
    cnpj { company.cnpj }
    company_name { company.name }
    admin { false }

    after(:create) { |u| u.update_column(:admin, false) }

    trait :admin do
      after(:create) { |u| u.update_column(:admin, true) }
    end
  end
end
