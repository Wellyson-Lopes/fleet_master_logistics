# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Machineries', type: :request do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  let!(:machinery) { create(:machinery, company: company, name: 'Escavadeira Hidráulica 20T') }

  before { sign_in user }

  describe 'GET /machineries' do
    it 'lista as máquinas e equipamentos da empresa' do
      get machineries_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Escavadeira Hidráulica 20T')
    end
  end

  describe 'POST /machineries' do
    it 'cadastra um novo equipamento' do
      post machineries_path, params: {
        machinery: {
          name: 'Trator de Esteira D6',
          category: 'terraplanagem',
          brand: 'Caterpillar',
          hourly_rate: 180.0,
          daily_rate: 1400.0,
          status: 'available'
        }
      }

      new_machinery = Machinery.find_by!(name: 'Trator de Esteira D6')
      expect(response).to redirect_to(machinery_path(new_machinery))
      expect(new_machinery.name).to eq('Trator de Esteira D6')
    end
  end
end
