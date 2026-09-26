# frozen_string_literal: true

FactoryBot.define do
  factory :trip do
    association :company
    association :vehicle
    association :driver

    code { "TRP-#{SecureRandom.hex(3).upcase}" }
    origin { 'São Paulo - SP' }
    destination { 'Curitiba - PR' }
    client_name { 'Construtora Teste LTDA' }
    cargo_description { 'Cimento e Argamassa' }
    cargo_weight_kg { 15_000 }
    freight_value { 5000.00 }
    distance_km { 400 }
    status { 'scheduled' }

    before(:create) do |trip|
      trip.vehicle.company = trip.company
      trip.vehicle.save! if trip.vehicle.changed?

      trip.driver.company = trip.company
      trip.driver.save! if trip.driver.changed?
    end
  end
end
