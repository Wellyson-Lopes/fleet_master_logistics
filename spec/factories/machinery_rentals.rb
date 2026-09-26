# frozen_string_literal: true

FactoryBot.define do
  factory :machinery_rental do
    association :company
    association :machinery
    association :client
    rental_type { 'daily' }
    duration { 3 }
    rate_applied { 1400.0 }
    total_amount { 4200.0 }
    start_date { Time.current }
    status { 'active' }
    delivery_address { 'Obra Suape Lote 5' }
  end
end
