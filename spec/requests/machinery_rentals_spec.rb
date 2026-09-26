# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MachineryRentals', type: :request do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  let(:client) { create(:client, company: company) }
  let(:machinery) { create(:machinery, company: company) }
  let!(:rental) { create(:machinery_rental, company: company, client: client, machinery: machinery) }

  before { sign_in user }

  describe 'GET /machinery_rentals' do
    it 'lista os contratos de locação' do
      get machinery_rentals_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(rental.code)
    end

    it 'renderiza a página de detalhes da locação com link de cobrança' do
      get machinery_rental_path(rental)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Emitir Cobrança Asaas')
      expect(response.body).to include(rental.code)
    end

    it 'exporta para CSV' do
      get machinery_rentals_path(format: :csv)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('text/csv')
    end
  end

  describe 'PATCH /machinery_rentals/:id/complete' do
    it 'finaliza a locação' do
      patch complete_machinery_rental_path(rental)
      expect(response).to redirect_to(machinery_rental_path(rental))
      expect(rental.reload.status).to eq('completed')
    end
  end
end
