# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Trip, type: :model do
  let(:company) { create(:company) }
  let(:vehicle) { create(:vehicle, company: company, load_capacity_kg: 20000) }
  let(:driver) { create(:driver, company: company) }
  let(:trip) { build(:trip, company: company, vehicle: vehicle, driver: driver, cargo_weight_kg: 15000) }

  describe 'validações' do
    it { should validate_presence_of(:origin) }
    it { should validate_presence_of(:destination) }
    it { should validate_presence_of(:client_name) }
    it { should validate_presence_of(:cargo_description) }
    it { should validate_inclusion_of(:status).in_array(Trip::STATUSES) }
    it { should validate_numericality_of(:cargo_weight_kg).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:freight_value).is_greater_than_or_equal_to(0) }
  end

  describe '#capacity_occupancy_percentage' do
    it 'calcula a porcentagem correta em relação à capacidade do veículo' do
      expect(trip.capacity_occupancy_percentage).to eq(75.0)
    end
  end

  describe '#overweight?' do
    it 'retorna false quando o peso da carga respeita o limite do caminhão' do
      expect(trip.overweight?).to be false
    end

    it 'retorna true quando o peso da carga excede o limite do caminhão' do
      trip.cargo_weight_kg = 25000
      expect(trip.overweight?).to be true
    end
  end

  describe 'isolamento multi-tenant' do
    it 'impede associar veículo e motorista de empresas diferentes' do
      other_company = create(:company)
      other_vehicle = create(:vehicle, company: other_company)
      invalid_trip = build(:trip, company: company, vehicle: other_vehicle, driver: driver)

      expect(invalid_trip.valid?).to be false
      expect(invalid_trip.errors[:base]).to include('Veículo e motorista devem pertencer à mesma empresa.')
    end
  end
end
