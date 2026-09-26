# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Drivers::Vehicles', type: :request do
  let(:company) { create(:company) }
  let(:driver) { create(:driver, company: company) }
  let(:vehicle) { create(:vehicle, company: company) }

  let(:token) do
    post '/api/v1/drivers/login', params: { driver: { email: driver.email, password: 'senha123' } }, as: :json
    response.headers['Authorization']
  end

  describe 'GET /api/v1/drivers/vehicle' do
    context 'quando o motorista tem um veículo alocado' do
      before do
        create(:vehicle_assignment, driver: driver, vehicle: vehicle, assigned_at: Time.current)
      end

      it 'retorna os dados do veículo' do
        get '/api/v1/drivers/vehicle',
            headers: { 'Authorization' => token, 'Accept' => 'application/json' }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('assigned')
        expect(json['vehicle']['plate']).to eq(vehicle.plate)
      end
    end

    context 'quando o motorista não tem veículo alocado' do
      it 'retorna status not_assigned' do
        get '/api/v1/drivers/vehicle',
            headers: { 'Authorization' => token, 'Accept' => 'application/json' }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('not_assigned')
        expect(json['vehicle']).to be_nil
      end
    end
  end
end
