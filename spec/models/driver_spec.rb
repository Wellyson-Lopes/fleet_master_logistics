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

    context 'quando o CNPJ não corresponde à empresa' do
      it 'adiciona erro de validação' do
        company = create(:company)
        driver = build(:driver, company: company, cnpj: CNPJ.generate)
        driver.valid?
        expect(driver.errors[:cnpj]).to include('não corresponde ao CNPJ da empresa')
      end
    end
  end

  describe 'multi-tenancy' do
    it 'inclui o concern TenantScoped' do
      expect(Driver.ancestors).to include(TenantScoped)
    end

    it 'pertence a uma empresa (company)' do
      expect(Driver.reflect_on_association(:company).macro).to eq(:belongs_to)
    end

    it 'filtra automaticamente por company_id via default_scope' do
      company_a = create(:company)
      company_b = create(:company)
      driver_a = create(:driver, company: company_a, cnpj: company_a.cnpj)
      Driver.unscoped.create!(
        company: company_b, cnpj: company_b.cnpj,
        email: "other_#{SecureRandom.hex(4)}@test.com",
        password: 'senha123', cpf: CPF.generate,
        cnh: '99999999', name: 'Outro Motorista'
      )

      allow(Current).to receive(:company).and_return(company_a)
      expect(Driver.all).to include(driver_a)
      expect(Driver.all.count).to eq(1)
    end
  end

  describe 'herança de dados do convite' do
    it 'herda company e cnpj do usuário que enviou o convite' do
      user = create(:user)
      driver = build(:driver, invited_by: user, invitation_token: 'token123')
      driver.valid?
      expect(driver.company).to eq(user.company)
      expect(driver.cnpj).to eq(user.cnpj)
    end
  end
end
