# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Drivers::HomeData', type: :request do
  let(:company) { create(:company) }
  let(:driver) { create(:driver, company: company, name: 'João Motorista', password: 'password123') }
  let(:vehicle) { create(:vehicle, company: company, plate: 'DEF-5555') }

  before do
    VehicleAssignment.create!(vehicle: vehicle, driver: driver, assigned_at: Time.current)
  end

  describe 'GET /api/v1/drivers/home_data' do
    it 'returns driver profile, company, and assigned vehicle info' do
      post '/api/v1/drivers/login', params: { driver: { email: driver.email, password: 'password123' } }, as: :json
      token = response.headers['Authorization']

      get '/api/v1/drivers/home_data', headers: { 'Authorization' => token }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['driver']['name']).to eq('João Motorista')
      expect(json['assigned_vehicle']['plate']).to eq('DEF-5555')
      expect(json['company']['name']).to eq(company.name)
    end
  end
end
