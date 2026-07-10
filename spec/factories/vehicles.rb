# frozen_string_literal: true

FactoryBot.define do
  factory :vehicle do
    association :company
    type { 'caminhão' }
    plate { "ABC-#{SecureRandom.random_number(1000..9999)}" }
    brand { 'Volvo' }
    model { 'FH 460' }
    year { 2022 }
    load_capacity_kg { 24_000 }
    current_mileage_km { 48_320 }
    status { 'active' }
  end
end
