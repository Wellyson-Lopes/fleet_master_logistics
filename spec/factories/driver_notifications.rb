# frozen_string_literal: true

FactoryBot.define do
  factory :driver_notification do
    company
    driver
    title { 'Nova viagem' }
    message { 'Você foi alocado em uma nova viagem' }
    notification_type { 'trip_assigned' }
    read { false }
  end
end
