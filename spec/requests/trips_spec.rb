# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Trips', type: :request do
  let(:company) { create(:company) }
  let(:user) { create(:user, :admin, company: company) }
  let(:vehicle) { create(:vehicle, company: company) }
  let(:driver) { create(:driver, company: company) }
  let!(:trip) { create(:trip, company: company, vehicle: vehicle, driver: driver, origin: 'São Paulo - SP', destination: 'Curitiba - PR', freight_value: 5000.0) }

  before do
    sign_in user
  end

  describe 'GET /trips' do
    it 'lista as viagens da empresa' do
      get trips_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include(trip.code)
      expect(response.body).to include('São Paulo - SP')
      expect(response.body).to include('Curitiba - PR')
    end

    it 'filtra viagens por status' do
      get trips_path, params: { status: 'scheduled' }
      expect(response).to have_http_status(:success)
      expect(response.body).to include(trip.code)
    end
  end

  describe 'POST /trips' do
    it 'cadastra uma nova viagem com sucesso' do
      expect {
        post trips_path, params: {
          trip: {
            vehicle_id: vehicle.id,
            driver_id: driver.id,
            origin: 'Belo Horizonte - MG',
            destination: 'Vitória - ES',
            client_name: 'Mineração Sudeste',
            cargo_description: 'Minério de Ferro',
            cargo_weight_kg: 24000,
            freight_value: 8200.00,
            distance_km: 510,
            status: 'scheduled'
          }
        }
      }.to change(Trip, :count).by(1)

      expect(response).to redirect_to(trip_path(Trip.order(created_at: :desc).first))
      follow_redirect!
      expect(response.body).to include('Belo Horizonte - MG')
      expect(response.body).to include('Minério de Ferro')
    end
  end

  describe 'PATCH /trips/:id/update_status' do
    it 'inicia a rota e atualiza status para in_transit' do
      patch update_status_trip_path(trip), params: { new_status: 'in_transit' }
      expect(response).to redirect_to(trip_path(trip))
      expect(trip.reload.status).to eq('in_transit')
      expect(trip.started_at).to be_present
    end

    it 'conclui a rota e atualiza status para delivered' do
      patch update_status_trip_path(trip), params: { new_status: 'delivered' }
      expect(response).to redirect_to(trip_path(trip))
      expect(trip.reload.status).to eq('delivered')
      expect(trip.delivered_at).to be_present
    end
  end
end
