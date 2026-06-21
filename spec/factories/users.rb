# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    association :company
    email { "user_#{SecureRandom.hex(4)}@exemplo.com" }
    password { 'senha123' }
    name { "Usuário #{SecureRandom.hex(2)}" }
    cnpj { company.cnpj }
    company_name { company.name }

    after(:create) do |user|
      user.update_column(:admin, false) if user.admin? && !user.invited?
    end

    trait :admin do
      after(:create) do |user|
        user.update_column(:admin, true)
      end
    end
  end
end
