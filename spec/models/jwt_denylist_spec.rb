# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtDenylist, type: :model do
  it 'inclui a estratégia de revogação Denylist' do
    expect(JwtDenylist.ancestors).to include(Devise::JWT::RevocationStrategies::Denylist)
  end

  it 'responde aos atributos jti e exp' do
    expect(subject).to respond_to(:jti)
    expect(subject).to respond_to(:exp)
  end
end
