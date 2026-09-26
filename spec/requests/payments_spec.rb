# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Payments', type: :request do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company, admin: true) }
  let(:client) { create(:client, company: company) }
  let!(:charge) { create(:asaas_charge, company: company, client: client) }

  before do
    sign_in user
  end

  describe 'GET /payments' do
    it 'lista as cobranças da empresa' do
      get payments_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(charge.asaas_id)
    end
  end

  describe 'GET /payments/new' do
    it 'renderiza o formulário de nova cobrança' do
      get new_payment_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /payments/:id' do
    it 'renderiza os detalhes da cobrança' do
      get payment_path(charge)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /payments' do
    let(:asaas_service_double) { instance_double(AsaasService) }

    before do
      allow(AsaasService).to receive(:new).and_return(asaas_service_double)
      allow(asaas_service_double).to receive(:find_or_create_customer).and_return({ 'id' => 'cus_123' })
      allow(asaas_service_double).to receive(:create_charge).and_return({
                                                                          'id' => 'pay_456',
                                                                          'invoiceUrl' => 'https://asaas.com/i/456',
                                                                          'bankSlipUrl' => 'https://asaas.com/b/456',
                                                                          'status' => 'PENDING'
                                                                        })
      allow(asaas_service_double).to receive(:get_pix_qr_code).and_return({
                                                                            'encodedImage' => 'base64image',
                                                                            'payload' => 'pixcopyandpaste'
                                                                          })
    end

    it 'cria uma nova cobrança e redireciona' do
      expect do
        post payments_path, params: {
          asaas_charge: {
            client_id: client.id,
            billing_type: 'PIX',
            value: 250.0,
            due_date: Date.current + 5.days,
            description: 'Serviço de Frete'
          }
        }
      end.to change(AsaasCharge, :count).by(1)

      new_charge = AsaasCharge.find_by(description: 'Serviço de Frete')
      expect(response).to redirect_to(payment_path(new_charge))
    end
  end
end
