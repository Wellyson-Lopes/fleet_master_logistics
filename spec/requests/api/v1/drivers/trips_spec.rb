# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Drivers::Trips', type: :request do
  let(:company) { create(:company) }
  let(:vehicle) { create(:vehicle, company: company) }
  let(:driver) { create(:driver, company: company) }
  let(:other_driver) { create(:driver, company: company) }
  let!(:trip) { create(:trip, company: company, vehicle: vehicle, driver: driver, status: 'scheduled') }
  let!(:other_trip) { create(:trip, company: company, vehicle: vehicle, driver: other_driver, status: 'scheduled') }

  let(:token) do
    post '/api/v1/drivers/login', params: { driver: { email: driver.email, password: 'senha123' } }, as: :json
    response.headers['Authorization']
  end

  describe 'GET /api/v1/drivers/trips' do
    it 'retorna apenas as viagens do motorista autenticado' do
      get '/api/v1/drivers/trips', headers: { 'Authorization' => token, 'Accept' => 'application/json' }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['trips'].size).to eq(1)
      expect(json['trips'].first['code']).to eq(trip.code)
    end
  end

  describe 'POST /api/v1/drivers/trips/:id/accept' do
    it 'permite ao motorista aceitar a viagem atribuída' do
      post "/api/v1/drivers/trips/#{trip.id}/accept",
           headers: { 'Authorization' => token, 'Accept' => 'application/json' }

      expect(response).to have_http_status(:ok)
      expect(trip.reload.status).to eq('accepted')
    end

    it 'bloqueia a tentativa de aceitar viagem de outro motorista' do
      post "/api/v1/drivers/trips/#{other_trip.id}/accept",
           headers: { 'Authorization' => token, 'Accept' => 'application/json' }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PATCH /api/v1/drivers/trips/:id/status' do
    it 'atualiza o status para em rota' do
      patch "/api/v1/drivers/trips/#{trip.id}/status",
            params: { status: 'in_transit' },
            headers: { 'Authorization' => token, 'Accept' => 'application/json' }

      expect(response).to have_http_status(:ok)
      expect(trip.reload.status).to eq('in_transit')
    end

    it 'registra ocorrência de incidente quando a entrega não pôde ser realizada' do
      patch "/api/v1/drivers/trips/#{trip.id}/status",
            params: { status: 'not_delivered', reason: 'quebra', notes: 'Pneu estourou na rodovia' },
            headers: { 'Authorization' => token, 'Accept' => 'application/json' }

      expect(response).to have_http_status(:ok)
      expect(trip.reload.status).to eq('not_delivered')
      expect(trip.reload.status_reason).to eq('quebra')
      expect(trip.trip_status_updates.count).to eq(1)
      expect(trip.trip_status_updates.first.reason).to eq('quebra')
    end
  end

  describe 'POST /api/v1/drivers/refuels' do
    before do
      VehicleAssignment.create!(vehicle: vehicle, driver: driver, assigned_at: Time.current)
    end

    it 'permite ao motorista registrar um abastecimento' do
      post '/api/v1/drivers/refuels',
           params: {
             refuel: {
               vehicle_id: vehicle.id,
               current_mileage_km: 154_000,
               liters: 80.5,
               total_amount: 480.0,
               fuel_type: 'diesel_s10',
               notes: 'Posto Petrobras BR-101'
             }
           },
           headers: { 'Authorization' => token, 'Accept' => 'application/json' }

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['data']['liters']).to eq(80.5)
      expect(FuelRefuel.count).to eq(1)
      expect(company.notifications.where(notification_type: 'fuel_refuel').count).to eq(1)
    end
  end
end
