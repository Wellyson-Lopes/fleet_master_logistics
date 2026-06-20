# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    association :company
    email { Faker::Internet.email }
    password { 'senha123' }
    name { Faker::Name.name }
    cnpj { company.cnpj }
    company_name { company.name }
    admin { false }

    trait :admin do
      admin { true }
    end
  end
end
