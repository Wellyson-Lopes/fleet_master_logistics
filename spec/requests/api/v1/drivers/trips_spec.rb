# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Drivers::Trips', type: :request do
  let(:company) { create(:company) }
  let(:vehicle) { create(:vehicle, company: company) }
  let(:driver) { create(:driver, company: company) }
  let!(:trip) { create(:trip, company: company, vehicle: vehicle, driver: driver, status: 'in_transit') }

  let(:token) do
    post '/api/v1/drivers/login', params: { driver: { email: driver.email, password: 'senha123' } }, as: :json
    response.headers['Authorization']
  end

  describe 'GET /api/v1/drivers/trips' do
    it 'retorna a lista de viagens do motorista' do
      get '/api/v1/drivers/trips', headers: { 'Authorization' => token, 'Accept' => 'application/json' }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['trips'].size).to eq(1)
      expect(json['trips'].first['code']).to eq(trip.code)
      expect(json['trips'].first['status']).to eq('in_transit')
    end
  end

  describe 'PATCH /api/v1/drivers/trips/:id/update_status' do
    it 'atualiza o status da entrega pelo aplicativo mobile' do
      patch "/api/v1/drivers/trips/#{trip.id}/update_status",
            params: { status: 'delivered' },
            headers: { 'Authorization' => token, 'Accept' => 'application/json' }

      expect(response).to have_http_status(:ok)
      expect(trip.reload.status).to eq('delivered')
    end
  end
end
