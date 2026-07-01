# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Drivers::Invitations', type: :request do
  let(:company) { create(:company) }
  let(:driver) { Driver.invite!(email: 'new@driver.com', company_id: company.id, cnpj: company.cnpj) }
  let(:invitation_token) { driver.raw_invitation_token }

  describe 'POST /api/v1/drivers/invitation/accept' do
    let(:url) { '/api/v1/drivers/invitation/accept' }
    let(:params) do
      {
        driver: {
          invitation_token: invitation_token,
          password: 'password123',
          password_confirmation: 'password123',
          name: 'Motorista Validado',
          cpf: CPF.generate,
          cnh: '998877'
        }
      }
    end

    it 'aceita o convite e retorna sucesso' do
      post url, params: params, as: :json
      expect(response).to have_http_status(:ok)
      expect(json_response['status']['message']).to eq('Cadastro finalizado com sucesso!')
    end

    it 'retorna o token JWT no header após o aceite' do
      post url, params: params, as: :json
      expect(response.headers['Authorization']).to be_present
    end

    it 'retorna erros para token inválido no formato padrão' do
      post url, params: { driver: { invitation_token: 'invalid' } }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['status']['code']).to eq(422)
      expect(json_response['status']['message']).to eq('Erro ao processar convite.')
      expect(json_response['errors']).to be_a(Hash)
      expect(json_response['errors']['invitation_token']).to be_present
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
