# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckExpiringDocumentsService do
  let(:company) { create(:company) }
  let!(:driver_expiring) do
    create(:driver, company: company, cnh_expiration: 10.days.from_now.to_date)
  end
  let!(:vehicle_expiring) do
    create(:vehicle, company: company, crlv_expiration: 5.days.from_now.to_date)
  end

  it 'gera alertas de documentos prestes a vencer' do
    expect do
      described_class.call
    end.to change(DriverNotification, :count).by(1)
                                             .and change(Notification, :count).by(2)
  end
end
