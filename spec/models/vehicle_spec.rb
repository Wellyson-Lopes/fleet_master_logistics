# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe 'validações' do
    subject { build(:vehicle) }

    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:plate) }
    it { should validate_uniqueness_of(:plate).case_insensitive }

    it 'valida status dentro da lista permitida' do
      vehicle = build(:vehicle, status: 'invalid')
      vehicle.valid?
      expect(vehicle.errors[:status]).to include('não está incluído(a) na lista')
    end

    it 'aceita status válidos' do
      %w[active maintenance inactive].each do |s|
        vehicle = create(:vehicle, status: s)
        expect(vehicle).to be_valid
      end
    end

    it 'valida que load_capacity_kg é maior que 0' do
      vehicle = build(:vehicle, load_capacity_kg: -1)
      vehicle.valid?
      expect(vehicle.errors[:load_capacity_kg]).to include('deve ser maior que 0')
    end

    it 'permite load_capacity_kg nil' do
      vehicle = create(:vehicle, load_capacity_kg: nil)
      expect(vehicle).to be_valid
    end

    it 'valida ano dentro do intervalo aceitável' do
      vehicle = build(:vehicle, year: 1899)
      vehicle.valid?
      expect(vehicle.errors[:year]).to include('deve ser maior ou igual a 1900')
    end

    it 'permite year nil' do
      vehicle = create(:vehicle, year: nil)
      expect(vehicle).to be_valid
    end
  end

  describe 'associações' do
    it { should belong_to(:company) }
    it { should have_many(:vehicle_assignments).dependent(:destroy) }
    it { should have_many(:drivers).through(:vehicle_assignments) }
  end

  describe 'multi-tenancy' do
    it 'inclui o concern TenantScoped' do
      expect(Vehicle.ancestors).to include(TenantScoped)
    end

    it 'filtra automaticamente por company_id via default_scope' do
      company_a = create(:company)
      company_b = create(:company)

      vehicle_a = create(:vehicle, company: company_a)
      create(:vehicle, company: company_b)

      allow(Current).to receive(:company).and_return(company_a)
      expect(Vehicle.all).to include(vehicle_a)
      expect(Vehicle.all.count).to eq(1)
    end
  end

  describe 'scopes' do
    let(:company) { create(:company) }

    before do
      allow(Current).to receive(:company).and_return(company)
    end

    it '.by_type filtra por tipo' do
      create(:vehicle, type: 'caminhão', company: company)
      create(:vehicle, type: 'trator', company: company)

      result = Vehicle.by_type('caminhão')
      expect(result.count).to eq(1)
      expect(result.first.type).to eq('caminhão')
    end

    it '.active retorna apenas veículos ativos' do
      active = create(:vehicle, status: 'active', company: company)
      create(:vehicle, status: 'maintenance', company: company)

      expect(Vehicle.active).to include(active)
      expect(Vehicle.active.count).to eq(1)
    end
  end

  describe 'STI desabilitado' do
    it 'permite usar type como campo livre sem STI' do
      vehicle = create(:vehicle, type: 'escavadeira')
      expect(vehicle.type).to eq('escavadeira')
      expect(vehicle).to be_a(Vehicle)
    end
  end
end
