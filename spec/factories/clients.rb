# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    association :company
    name { 'Construtora Horizonte LTDA' }
    document { '12.345.678/0001-90' }
    email { 'contato@horizonte.com.br' }
    phone { '(81) 98888-7777' }
    address { 'Av. Principal, 1000' }
    city { 'Recife' }
    state { 'PE' }
    zip_code { '50000-000' }
    status { 'active' }
  end
end
