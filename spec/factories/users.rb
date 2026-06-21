# frozen_string_literal: true

FactoryBot.define do
  factory :system_user, class: 'User' do
    association :company
    email { 'system@fleetmaster.com' }
    password { 'senha123' }
    name { 'Sistema' }
    cnpj { company.cnpj }
    company_name { company.name }
    admin { true }
    invited_by { nil }

    after(:create) { |u| u.update_column(:admin, true) }
  end

  factory :user do
    association :company
    email { "user_#{SecureRandom.hex(4)}@exemplo.com" }
    password { 'senha123' }
    name { "Usuário #{SecureRandom.hex(2)}" }
    cnpj { company.cnpj }
    company_name { company.name }
    invited_by { association(:system_user) }
    admin { false }

    trait :admin do
      admin { true }
    end
  end
end
