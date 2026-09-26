# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Webhooks::Asaas', type: :request do
  let(:company) { create(:company) }
  let(:client) { create(:client, company: company) }
  let!(:charge) { create(:asaas_charge, company: company, client: client, asaas_id: 'pay_test123', status: 'PENDING') }

  describe 'POST /webhooks/asaas' do
    it 'processa pagamento recebido com sucesso' do
      post '/webhooks/asaas', params: {
        event: 'PAYMENT_RECEIVED',
        payment: {
          id: 'pay_test123',
          paymentDate: '2026-09-26',
          netValue: 495.0
        }
      }, as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('processed')
      expect(charge.reload.status).to eq('RECEIVED')
      expect(charge.net_value).to eq(495.0)
    end

    it 'processa pagamento vencido' do
      post '/webhooks/asaas', params: {
        event: 'PAYMENT_OVERDUE',
        payment: {
          id: 'pay_test123'
        }
      }, as: :json

      expect(response).to have_http_status(:ok)
      expect(charge.reload.status).to eq('OVERDUE')
    end

    it 'retorna status ignored quando cobrança não é encontrada' do
      post '/webhooks/asaas', params: {
        event: 'PAYMENT_RECEIVED',
        payment: {
          id: 'pay_inexistente'
        }
      }, as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('ignored')
    end
  end
end
