# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Drivers::Locations', type: :request do
  let(:company) { create(:company) }
  let(:driver) { create(:driver, company: company) }
  let(:vehicle) { create(:vehicle, company: company) }
  let(:trip) { create(:trip, company: company, vehicle: vehicle, driver: driver) }

  let(:token) do
    post '/api/v1/drivers/login', params: { driver: { email: driver.email, password: 'senha123' } }, as: :json
    response.headers['Authorization']
  end

  describe 'POST /api/v1/drivers/location' do
    it 'registra localização com sucesso' do
      expect do
        post '/api/v1/drivers/location',
             params: {
               location: {
                 latitude: -8.0578,
                 longitude: -34.8829,
                 speed: 60.0,
                 heading: 180.0,
                 trip_id: trip.id
               }
             },
             headers: { 'Authorization' => token, 'Accept' => 'application/json' },
             as: :json
      end.to change(DriverLocation, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('success')
      expect(json['data']['latitude']).to eq(-8.0578)
      expect(json['data']['longitude']).to eq(-34.8829)
    end
  end
end
