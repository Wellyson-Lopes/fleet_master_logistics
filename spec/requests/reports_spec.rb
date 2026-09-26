# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports', type: :request do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  let(:vehicle) { create(:vehicle, company: company, load_capacity_kg: 24000) }
  let(:driver) { create(:driver, company: company) }

  before do
    sign_in user
  end

  context 'com viagens cadastradas' do
    before do
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

      it 'exporta para CSV/Excel com sucesso' do
        get reports_path(format: :csv)
        expect(response).to have_http_status(:success)
        expect(response.content_type).to include('text/csv')
        expect(response.body).to include('Código da Viagem')
        expect(response.body).to include(driver.name)
      end

      it 'renderiza a view de impressão / PDF com sucesso' do
        get print_pdf_reports_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('Relatório Consolidado de Desempenho')
        expect(response.body).to include(driver.name)
      end
    end
  end

  context 'sem viagens cadastradas (empresa nova ou vazia)' do
    it 'renderiza o relatório vazio sem erros' do
      get reports_path
      expect(response).to have_http_status(:success)
    end

    it 'exporta o CSV/Excel vazio sem erros' do
      get reports_path(format: :csv)
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Código da Viagem')
    end

    it 'renderiza a view de impressão / PDF vazia sem erros' do
      get print_pdf_reports_path
      expect(response).to have_http_status(:success)
    end
  end
end
