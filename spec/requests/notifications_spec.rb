# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  let!(:notification) do
    company.notifications.create!(
      title: 'Incidente Registrado',
      message: 'Motorista parou por quebra mecânica',
      notification_type: 'incident'
    )
  end

  before { sign_in user }

  describe 'GET /notifications' do
    it 'renderiza a lista de notificações da empresa' do
      get notifications_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Incidente Registrado')
    end

    it 'retorna formato JSON' do
      get notifications_path, headers: { 'Accept' => 'application/json' }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['unread_count']).to eq(1)
      expect(json['notifications'].first['title']).to eq('Incidente Registrado')
    end
  end

  describe 'PATCH /notifications/:id/read' do
    it 'marca a notificação como lida' do
      patch read_notification_path(notification)
      expect(response).to redirect_to(notifications_path)
      expect(notification.reload.read).to be(true)
    end
  end

  describe 'POST /notifications/read_all' do
    it 'marca todas as notificações da empresa como lidas' do
      post read_all_notifications_path
      expect(response).to redirect_to(notifications_path)
      expect(company.notifications.unread.count).to eq(0)
    end
  end
end
