# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Drivers', type: :request do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company, admin: true) }

  before do
    sign_in user
  end

  describe 'GET /drivers' do
    it 'lists company drivers' do
      driver = create(:driver, company: company)
      get drivers_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include(driver.email)
    end
  end

  describe 'PATCH /drivers/:id' do
    it 'updates driver details' do
      driver = create(:driver, company: company)
      patch driver_path(driver), params: { driver: { phone: '(81) 98888-7777', name: 'Motorista Teste' } }
      expect(response).to redirect_to(driver_path(driver))
      expect(driver.reload.phone).to eq('(81) 98888-7777')
    end
  end
end
