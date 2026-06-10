# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Drivers::Sessions', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:company) { create(:company) }
  let(:driver) { create(:driver, company: company, password: 'password123') }

  describe 'POST /api/v1/drivers/login' do
    let(:url) { '/api/v1/drivers/login' }
    let(:params) do
      {
        driver: {
          email: driver.email,
          password: 'password123'
        }
      }
    end

    it 'retorna login com sucesso' do
      post url, params: params, as: :json
      expect(response).to have_http_status(:ok)
      expect(json_response['status']['message']).to eq('Logado com sucesso.')
    end

    it 'retorna o token JWT no header Authorization' do
      post url, params: params, as: :json
      expect(response.headers['Authorization']).to be_present
      expect(response.headers['Authorization']).to start_with('Bearer ')
    end

    it 'retorna não autorizado para credenciais inválidas' do
      post url, params: { driver: { email: driver.email, password: 'wrong' } }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE /api/v1/drivers/logout' do
    let(:url) { '/api/v1/drivers/logout' }

    it 'retorna logout com sucesso' do
      # Primeiro logar para pegar o token
      post '/api/v1/drivers/login', params: { driver: { email: driver.email, password: 'password123' } }, as: :json
      token = response.headers['Authorization']

      delete url, headers: { 'Authorization' => token }, as: :json
      expect(response).to have_http_status(:ok)
      expect(json_response['message']).to eq('Logout realizado com sucesso ou sessão encerrada.')
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
