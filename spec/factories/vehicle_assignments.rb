# frozen_string_literal: true

FactoryBot.define do
  factory :vehicle_assignment do
    association :vehicle
    association :driver
    assigned_at { Time.current }
  end
end
