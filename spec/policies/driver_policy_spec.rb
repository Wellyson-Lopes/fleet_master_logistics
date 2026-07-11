# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DriverPolicy do
  let!(:company) { create(:company) }
  let!(:other_company) { create(:company) }
  let!(:admin) { create(:user, :admin, company: company, cnpj: company.cnpj) }
  let!(:user) { create(:user, company: company, cnpj: company.cnpj) }
  let!(:driver) { create(:driver, company: company, cnpj: company.cnpj) }
  let!(:other_driver) { create(:driver, company: other_company, cnpj: other_company.cnpj) }

  describe '#index?' do
    context 'quando o usuário é admin' do
      it 'permite listar motoristas da empresa' do
        policy = described_class.new(admin, Driver)
        expect(policy.index?).to be true
      end
    end

    context 'quando o usuário é motorista' do
      it 'não permite listar outros motoristas' do
        policy = described_class.new(driver, Driver)
        expect(policy.index?).to be false
      end
    end

    context 'quando o usuário é usuário comum' do
      it 'não permite listar motoristas' do
        policy = described_class.new(user, Driver)
        expect(policy.index?).to be false
      end
    end
  end

  describe '#show?' do
    context 'quando o usuário é o próprio motorista' do
      it 'permite visualizar seu perfil' do
        policy = described_class.new(driver, driver)
        expect(policy.show?).to be true
      end
    end

    context 'quando o usuário é admin da mesma empresa' do
      it 'permite visualizar motoristas da empresa' do
        policy = described_class.new(admin, driver)
        expect(policy.show?).to be true
      end
    end

    context 'quando o usuário é admin de outra empresa' do
      it 'não permite visualizar motoristas de outra empresa' do
        policy = described_class.new(admin, other_driver)
        expect(policy.show?).to be false
      end
    end

    context 'quando o usuário é motorista tentando ver outro motorista' do
      it 'não permite visualizar' do
        policy = described_class.new(driver, other_driver)
        expect(policy.show?).to be false
      end
    end
  end

  describe '#create?' do
    context 'quando o usuário é admin' do
      it 'permite criar motoristas' do
        policy = described_class.new(admin, Driver)
        expect(policy.create?).to be true
      end
    end

    context 'quando o usuário é motorista' do
      it 'não permite criar motoristas' do
        policy = described_class.new(driver, Driver)
        expect(policy.create?).to be false
      end
    end

    context 'quando o usuário é usuário comum' do
      it 'não permite criar motoristas' do
        policy = described_class.new(user, Driver)
        expect(policy.create?).to be false
      end
    end
  end

  describe '#update?' do
    context 'quando o usuário é o próprio motorista' do
      it 'permite atualizar seu perfil' do
        policy = described_class.new(driver, driver)
        expect(policy.update?).to be true
      end
    end

    context 'quando o usuário é admin da mesma empresa' do
      it 'permite atualizar motoristas da empresa' do
        policy = described_class.new(admin, driver)
        expect(policy.update?).to be true
      end
    end

    context 'quando o usuário é admin de outra empresa' do
      it 'não permite atualizar motoristas de outra empresa' do
        policy = described_class.new(admin, other_driver)
        expect(policy.update?).to be false
      end
    end

    context 'quando o usuário é motorista tentando atualizar outro motorista' do
      it 'não permite atualizar' do
        policy = described_class.new(driver, other_driver)
        expect(policy.update?).to be false
      end
    end
  end

  describe '#destroy?' do
    context 'quando o usuário é admin da mesma empresa' do
      it 'permite remover motoristas da empresa' do
        policy = described_class.new(admin, driver)
        expect(policy.destroy?).to be true
      end
    end

    context 'quando o usuário é motorista' do
      it 'não permite remover motoristas' do
        policy = described_class.new(driver, driver)
        expect(policy.destroy?).to be false
      end
    end

    context 'quando o usuário é admin de outra empresa' do
      it 'não permite remover motoristas de outra empresa' do
        policy = described_class.new(admin, other_driver)
        expect(policy.destroy?).to be false
      end
    end
  end

  describe DriverPolicy::Scope do
    before do
      allow(Current).to receive(:company).and_return(company)
    end

    context 'quando o usuário é admin' do
      it 'retorna motoristas da empresa' do
        scope = DriverPolicy::Scope.new(admin, Driver).resolve
        expect(scope).to include(driver)
        expect(scope).not_to include(other_driver)
      end
    end

    context 'quando o usuário é motorista' do
      it 'não retorna motoristas' do
        scope = DriverPolicy::Scope.new(driver, Driver).resolve
        expect(scope).to be_empty
      end
    end
  end
end
