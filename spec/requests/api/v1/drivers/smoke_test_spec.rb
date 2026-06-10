# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Driver API Smoke Test', type: :request do
  # Este teste realiza o "Caminho Feliz" completo do motorista na API.
  # Serve como um indicador rápido de integridade do sistema de motoristas.

  let(:company) { create(:company) }
  let(:driver_email) { "driver.smoke.#{SecureRandom.hex(4)}@test.com" }
  let(:password) { 'password123' }

  def json
    JSON.parse(response.body)
  end

  it 'valida a integridade do ciclo de vida: convite -> aceite -> login -> perfil -> logout' do
    # 1. Convite
    driver = Driver.invite!(email: driver_email, company_id: company.id, cnpj: company.cnpj)
    invitation_token = driver.raw_invitation_token
    expect(driver.invitation_token).to be_present

    # 2. Aceite de Convite via API
    post '/api/v1/drivers/invitation/accept', params: {
      driver: {
        invitation_token: invitation_token,
        password: password,
        password_confirmation: password,
        name: 'Smoke Test Driver',
        cpf: CPF.generate,
        cnh: SecureRandom.random_number(10**10).to_s
      }
    }, as: :json
    expect(response).to have_http_status(:ok)

    # Captura Token inicial
    auth_token = response.headers['Authorization']
    expect(auth_token).to be_present

    # 3. Login Formal via API
    post '/api/v1/drivers/login', params: {
      driver: { email: driver_email, password: password }
    }, as: :json
    expect(response).to have_http_status(:ok)
    auth_token = response.headers['Authorization']

    # 4. Verificação de Perfil (Acesso autenticado)
    get '/api/v1/drivers/profile', headers: { 'Authorization' => auth_token }, as: :json
    expect(response).to have_http_status(:ok)
    expect(json['data']['name']).to eq('Smoke Test Driver')

    # 5. Edição Rápida
    patch '/api/v1/drivers/profile',
          params: { driver: { name: 'Smoke Test Updated' } },
          headers: { 'Authorization' => auth_token },
          as: :json
    expect(response).to have_http_status(:ok)

    # 6. Logout
    delete '/api/v1/drivers/logout', headers: { 'Authorization' => auth_token }, as: :json
    expect(response).to have_http_status(:ok)

    # 7. Verificação de Revogação (Proteção)
    get '/api/v1/drivers/profile', headers: { 'Authorization' => auth_token }, as: :json
    expect(response).to have_http_status(:unauthorized)
  end

  it 'bloqueia acesso a rotas protegidas sem token' do
    get '/api/v1/drivers/profile', as: :json
    expect(response).to have_http_status(:unauthorized)
  end
end
