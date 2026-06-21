# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    association :company
    email { "user_#{SecureRandom.hex(4)}@exemplo.com" }
    password { 'senha123' }
    name { "Usuário #{SecureRandom.hex(2)}" }
    cnpj { company.cnpj }
    company_name { company.name }

    transient do
      skip_set_admin { false }
    end

    after(:create) do |user, evaluator|
      user.update_column(:admin, false) unless evaluator.skip_set_admin
    end

    trait :admin do
      skip_set_admin { true }
      after(:create) { |u| u.update_column(:admin, true) }
    end
  end
end
