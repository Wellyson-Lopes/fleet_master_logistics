# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FuelRefuel, type: :model do
  let(:company) { create(:company) }
  let(:vehicle) { create(:vehicle, company: company) }
  let(:driver) { create(:driver, company: company) }

  it 'é válido com atributos válidos' do
    refuel = described_class.new(
      company: company,
      vehicle: vehicle,
      driver: driver,
      current_mileage_km: 120_000,
      liters: 150.0,
      total_amount: 900.0,
      fuel_type: 'diesel_s10'
    )
    expect(refuel).to be_valid
  end

  it 'invalida se litragem ou valor forem negativos ou zero' do
    refuel = described_class.new(
      company: company,
      vehicle: vehicle,
      driver: driver,
      current_mileage_km: 120_000,
      liters: 0,
      total_amount: -50.0,
      fuel_type: 'diesel_s10'
    )
    expect(refuel).not_to be_valid
  end
end
