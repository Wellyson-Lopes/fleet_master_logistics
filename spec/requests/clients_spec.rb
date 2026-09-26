# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Clients', type: :request do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  let!(:client) { create(:client, company: company, name: 'Distribuidora ABC') }

  before { sign_in user }

  describe 'GET /clients' do
    it 'lista clientes da empresa' do
      get clients_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Distribuidora ABC')
    end
  end

  describe 'POST /clients' do
    it 'cria um novo cliente com sucesso' do
      post clients_path, params: {
        client: {
          name: 'Supermercado Progresso',
          document: '12.345.678/0001-90',
          email: 'contato@progresso.com',
          phone: '(11) 98888-7777',
          city: 'São Paulo',
          state: 'SP',
          status: 'active'
        }
      }

      new_client = Client.find_by!(name: 'Supermercado Progresso')
      expect(response).to redirect_to(client_path(new_client))
      expect(new_client.name).to eq('Supermercado Progresso')
    end
  end
end
