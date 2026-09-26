# frozen_string_literal: true

FactoryBot.define do
  factory :machinery do
    association :company
    name { 'Escavadeira CAT 320' }
    category { 'Escavadeira Hidráulica' }
    brand { 'Caterpillar' }
    model { '320D' }
    year { 2023 }
    serial_number { "CAT-#{SecureRandom.hex(4).upcase}" }
    hourly_rate { 180.0 }
    daily_rate { 1400.0 }
    status { 'available' }
  end
end
