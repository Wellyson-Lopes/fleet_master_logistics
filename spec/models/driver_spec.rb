# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Driver, type: :model do
  describe 'validações' do
    subject { build(:driver) }

    it { should validate_presence_of(:cnpj) }
    it { should validate_uniqueness_of(:cpf).case_insensitive.allow_blank }
    it { should validate_uniqueness_of(:cnh).case_insensitive.allow_blank }

    context 'quando o convite é aceito' do
      before { allow(subject).to receive(:invitation_accepted_at?).and_return(true) }
      it { should validate_presence_of(:name).on(:update) }
    end

    it 'valida o formato do CPF' do
      subject.cpf = '123'
      subject.valid?
      expect(subject.errors[:cpf]).to include('não é válido')
    end

    it 'valida o formato do CNPJ' do
      subject.cnpj = '123'
      subject.valid?
      expect(subject.errors[:cnpj]).to include('não é válido')
    end
  end

  describe 'multi-tenancy' do
    it 'inclui o concern TenantScoped' do
      expect(Driver.ancestors).to include(TenantScoped)
    end

    it 'pertence a uma empresa (company)' do
      expect(Driver.reflect_on_association(:company).macro).to eq(:belongs_to)
    end
  end
end
