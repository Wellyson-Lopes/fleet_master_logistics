# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TripStatusUpdate, type: :model do
  let(:company) { create(:company) }
  let(:vehicle) { create(:vehicle, company: company) }
  let(:driver) { create(:driver, company: company) }
  let(:trip) { create(:trip, company: company, vehicle: vehicle, driver: driver) }

  it 'é válido com atributos corretos' do
    update = described_class.new(
      company: company,
      trip: trip,
      driver: driver,
      status: 'in_transit',
      reason: 'outro',
      notes: 'Trânsito liberado'
    )
    expect(update).to be_valid
  end

  it 'pertence à empresa (TenantScoped)' do
    update = described_class.create!(
      company: company,
      trip: trip,
      driver: driver,
      status: 'delivered'
    )
    expect(update.company_id).to eq(company.id)
  end

  it 'retorna texto humanizado do motivo' do
    update = described_class.new(reason: 'quebra')
    expect(update.reason_human).to eq('Falha Mecânica / Quebra')
  end
end
