# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports', type: :request do
  let(:company) { create(:company) }
  let(:user) { create(:user, :admin, company: company) }
  let(:vehicle) { create(:vehicle, company: company, load_capacity_kg: 24000) }
  let(:driver) { create(:driver, company: company) }

  before do
    sign_in user
    create(:trip, company: company, vehicle: vehicle, driver: driver, freight_value: 6000.0, cargo_weight_kg: 20000, status: 'delivered')
  end

  describe 'GET /reports' do
    it 'renderiza a página de relatórios com os dados consolidados' do
      get reports_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Relatórios & Análise de Fretes')
      expect(response.body).to include(driver.name)
      expect(response.body).to include(vehicle.plate)
    end

    it 'permite filtrar por período' do
      get reports_path, params: { period: 'last_30_days' }
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Faturamento em Fretes')
    end
  end
end
