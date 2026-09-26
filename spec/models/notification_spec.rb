# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:company) { create(:company) }

  it 'é válida com campos obrigatórios' do
    notif = described_class.new(
      company: company,
      title: 'Aviso de Teste',
      message: 'Mensagem de notificação operacional',
      notification_type: 'incident'
    )
    expect(notif).to be_valid
  end

  it 'marca como lida com sucesso' do
    notif = described_class.create!(
      company: company,
      title: 'Aviso',
      message: 'Corpo',
      notification_type: 'system'
    )
    expect(notif.read).to be(false)
    notif.mark_as_read!
    expect(notif.read).to be(true)
    expect(notif.read_at).to be_present
  end
end
