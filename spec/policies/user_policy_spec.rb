# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy do
  let!(:company) { create(:company) }
  let!(:other_company) { create(:company) }
  let!(:admin) { create(:user, company: company, cnpj: company.cnpj, admin: true) }
  let!(:user) { create(:user, company: company, cnpj: company.cnpj) }
  let!(:other_user) { create(:user, company: other_company, cnpj: other_company.cnpj) }

  describe '#index?' do
    context 'quando o usuário é admin' do
      it 'permite listar usuários da empresa' do
        policy = described_class.new(admin, User)
        expect(policy.index?).to be true
      end
    end

    context 'quando o usuário é usuário comum' do
      it 'permite listar usuários da empresa' do
        policy = described_class.new(user, User)
        expect(policy.index?).to be true
      end
    end

    context 'quando o usuário não tem empresa' do
      it 'não permite listar usuários' do
        user_without_company = build(:user, company: nil)
        policy = described_class.new(user_without_company, User)
        expect(policy.index?).to be false
      end
    end
  end

  describe '#show?' do
    context 'quando o usuário é o próprio usuário' do
      it 'permite visualizar seu perfil' do
        policy = described_class.new(user, user)
        expect(policy.show?).to be true
      end
    end

    context 'quando o usuário é admin da mesma empresa' do
      it 'permite visualizar usuários da empresa' do
        policy = described_class.new(admin, user)
        expect(policy.show?).to be true
      end
    end

    context 'quando o usuário é usuário comum da mesma empresa' do
      it 'permite visualizar outros usuários da empresa' do
        policy = described_class.new(user, admin)
        expect(policy.show?).to be true
      end
    end

    context 'quando o usuário é de outra empresa' do
      it 'não permite visualizar usuários de outra empresa' do
        policy = described_class.new(admin, other_user)
        expect(policy.show?).to be false
      end
    end
  end

  describe '#create?' do
    context 'quando o usuário é admin' do
      it 'permite criar usuários' do
        policy = described_class.new(admin, User)
        expect(policy.create?).to be true
      end
    end

    context 'quando o usuário é usuário comum' do
      it 'não permite criar usuários' do
        policy = described_class.new(user, User)
        expect(policy.create?).to be false
      end
    end
  end

  describe '#update?' do
    context 'quando o usuário é o próprio usuário' do
      it 'permite atualizar seu perfil' do
        policy = described_class.new(user, user)
        expect(policy.update?).to be true
      end
    end

    context 'quando o usuário é admin da mesma empresa' do
      it 'permite atualizar usuários da empresa' do
        policy = described_class.new(admin, user)
        expect(policy.update?).to be true
      end
    end

    context 'quando o usuário é usuário comum da mesma empresa' do
      it 'não permite atualizar outros usuários' do
        policy = described_class.new(user, admin)
        expect(policy.update?).to be false
      end
    end

    context 'quando o usuário é de outra empresa' do
      it 'não permite atualizar usuários de outra empresa' do
        policy = described_class.new(admin, other_user)
        expect(policy.update?).to be false
      end
    end
  end

  describe '#destroy?' do
    context 'quando o usuário é admin da mesma empresa' do
      it 'permite remover usuários da empresa' do
        policy = described_class.new(admin, user)
        expect(policy.destroy?).to be true
      end

      it 'não permite remover a si mesmo' do
        policy = described_class.new(admin, admin)
        expect(policy.destroy?).to be false
      end
    end

    context 'quando o usuário é usuário comum' do
      it 'não permite remover usuários' do
        policy = described_class.new(user, user)
        expect(policy.destroy?).to be false
      end
    end
  end

  describe UserPolicy::Scope do
    context 'quando o usuário é admin' do
      it 'retorna usuários da empresa' do
        scope = UserPolicy::Scope.new(admin, User).resolve
        expect(scope).to include(user)
        expect(scope).not_to include(other_user)
      end
    end

    context 'quando o usuário é usuário comum' do
      it 'retorna usuários da empresa' do
        scope = UserPolicy::Scope.new(user, User).resolve
        expect(scope).to include(admin)
        expect(scope).not_to include(other_user)
      end
    end
  end
end
