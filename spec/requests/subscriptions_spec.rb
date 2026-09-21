# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Subscriptions', type: :request do
  let(:company) { create(:company, plan: 'starter') }
  let(:user) { create(:user, company: company, admin: true) }

  before do
    sign_in user
  end

  describe 'GET /subscriptions' do
    it 'renders subscription management view with active plan' do
      get subscriptions_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Meu Plano')
      expect(response.body).to include('Starter')
    end
  end

  describe 'PATCH /subscriptions/:id' do
    it 'upgrades plan to pro' do
      patch subscription_path, params: { company: { plan: 'pro' } }
      expect(response).to redirect_to(subscriptions_path)
      expect(company.reload.plan).to eq('pro')
    end
  end
end
