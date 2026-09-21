# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'validations and defaults' do
    subject(:company) { build(:company) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:cnpj) }

    it 'sets default trial period on creation' do
      comp = create(:company)
      expect(comp.plan).to eq('starter')
      expect(comp.billing_cycle).to eq('monthly')
      expect(comp.subscription_status).to eq('trialing')
      expect(comp.trial_ends_at).to be_present
      expect(comp.trial_days_remaining).to be >= 13
    end
  end

  describe '#plan_limits and restrictions' do
    it 'returns correct limits for starter plan' do
      company = create(:company, plan: 'starter')
      expect(company.plan_limits).to eq({ max_users: 3, max_drivers: 5, max_vehicles: 5 })
      expect(company.can_add_vehicle?).to be true
    end

    it 'returns correct limits for pro plan' do
      company = create(:company, plan: 'pro')
      expect(company.plan_limits).to eq({ max_users: 10, max_drivers: 20, max_vehicles: 20 })
    end

    it 'enforces vehicle creation limits' do
      company = create(:company, plan: 'starter')
      create_list(:vehicle, 5, company: company)
      expect(company.can_add_vehicle?).to be false
    end
  end
end
