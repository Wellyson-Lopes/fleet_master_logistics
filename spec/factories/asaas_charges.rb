# frozen_string_literal: true

FactoryBot.define do
  factory :asaas_charge do
    company
    client
    billing_type { 'PIX' }
    value { 500.0 }
    due_date { Date.current + 3.days }
    status { 'PENDING' }
    asaas_id { "pay_#{SecureRandom.hex(8)}" }
    description { 'Cobrança de teste' }
  end
end
