# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Drivers::Notifications', type: :request do
  let(:company) { create(:company) }
  let(:driver) { create(:driver, company: company) }
  let!(:notification) { create(:driver_notification, company: company, driver: driver, read: false) }

  let(:token) do
    post '/api/v1/drivers/login', params: { driver: { email: driver.email, password: 'senha123' } }, as: :json
    response.headers['Authorization']
  end

  describe 'GET /api/v1/drivers/notifications' do
    it 'retorna a lista de notificações do motorista' do
      get '/api/v1/drivers/notifications',
          headers: { 'Authorization' => token, 'Accept' => 'application/json' }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['unread_count']).to eq(1)
      expect(json['notifications'].size).to eq(1)
      expect(json['notifications'].first['title']).to eq(notification.title)
    end
  end

  describe 'PATCH /api/v1/drivers/notifications/:id/read' do
    it 'marca a notificação como lida' do
      patch "/api/v1/drivers/notifications/#{notification.id}/read",
            headers: { 'Authorization' => token, 'Accept' => 'application/json' }

      expect(response).to have_http_status(:ok)
      expect(notification.reload.read).to be(true)
    end
  end

  describe 'POST /api/v1/drivers/notifications/read_all' do
    it 'marca todas as notificações do motorista como lidas' do
      post '/api/v1/drivers/notifications/read_all',
           headers: { 'Authorization' => token, 'Accept' => 'application/json' }

      expect(response).to have_http_status(:ok)
      expect(notification.reload.read).to be(true)
    end
  end
end
