# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Vehicles', type: :request do
  let(:company) { create(:company) }
  let(:user) { create(:user, :admin, company: company) }

  before do
    sign_in user
  end

  describe 'GET /vehicles' do
    it 'returns http success and lists company vehicles' do
      vehicle = create(:vehicle, company: company)
      get vehicles_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include(vehicle.plate)
    end

    it 'does not show vehicles from another company' do
      other_company = create(:company)
      other_vehicle = create(:vehicle, company: other_company)
      get vehicles_path
      expect(response.body).not_to include(other_vehicle.plate)
    end
  end

  describe 'POST /vehicles' do
    it 'creates a new vehicle when under plan limit' do
      expect {
        post vehicles_path, params: {
          vehicle: {
            plate: 'ABC-9999',
            type: 'Caminhão Truck',
            brand: 'Volvo',
            model: 'FH 460',
            year: 2022,
            load_capacity_kg: 15000,
            status: 'active'
          }
        }
      }.to change(Vehicle, :count).by(1)

      expect(response).to redirect_to(vehicles_path)
      follow_redirect!
      expect(response.body).to include('ABC-9999')
    end

    it 'blocks creation if plan limit is reached' do
      create_list(:vehicle, 5, company: company) # Starter limit is 5
      post vehicles_path, params: {
        vehicle: {
          plate: 'XYZ-8888',
          type: 'Caminhão Truck'
        }
      }
      expect(response).to redirect_to(vehicles_path)
      follow_redirect!
      expect(response.body).to include('atingiu o limite')
    end
  end

  describe 'POST /vehicles/:id/assign_driver' do
    it 'assigns driver to vehicle' do
      vehicle = create(:vehicle, company: company)
      driver = create(:driver, company: company)

      post assign_driver_vehicle_path(vehicle), params: { driver_id: driver.id }

      expect(response).to redirect_to(vehicle_path(vehicle))
      expect(vehicle.reload.current_driver).to eq(driver)
    end
  end
end
