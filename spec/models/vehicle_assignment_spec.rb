# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VehicleAssignment, type: :model do
  describe 'validações' do
    subject { build(:vehicle_assignment) }

    it { should validate_presence_of(:assigned_at) }

    it 'valida que veículo e motorista pertencem à mesma empresa' do
      company_a = create(:company)
      company_b = create(:company)

      vehicle = create(:vehicle, company: company_a)
      driver = create(:driver, company: company_b, cnpj: company_b.cnpj)

      assignment = build(:vehicle_assignment, vehicle: vehicle, driver: driver)
      assignment.valid?
      expect(assignment.errors[:driver]).to include('não pertence à mesma empresa do veículo')
    end
  end

  describe 'associações' do
    it { should belong_to(:vehicle) }
    it { should belong_to(:driver) }
  end

  describe 'scopes' do
    let(:company) { create(:company) }
    let(:vehicle) { create(:vehicle, company: company) }
    let(:driver) { create(:driver, company: company, cnpj: company.cnpj) }

    it '.current retorna atribuições sem data de desatribuição' do
      current = create(:vehicle_assignment, vehicle: vehicle, driver: driver, assigned_at: 1.day.ago,
                                            unassigned_at: nil)
      create(:vehicle_assignment, vehicle: vehicle, driver: driver, assigned_at: 5.days.ago, unassigned_at: 2.days.ago)

      expect(VehicleAssignment.current).to include(current)
      expect(VehicleAssignment.current.count).to eq(1)
    end

    it '.for_date retorna atribuições vigentes em uma data específica' do
      assignment = create(:vehicle_assignment, vehicle: vehicle, driver: driver, assigned_at: 3.days.ago,
                                               unassigned_at: 1.day.ago)

      expect(VehicleAssignment.for_date(2.days.ago)).to include(assignment)
      expect(VehicleAssignment.for_date(5.days.ago)).to be_empty
    end
  end

  describe 'associação entre Driver e Vehicle' do
    it 'permite acessar veículos de um motorista através de vehicle_assignments' do
      company = create(:company)
      vehicle = create(:vehicle, company: company)
      driver = create(:driver, company: company, cnpj: company.cnpj)
      create(:vehicle_assignment, vehicle: vehicle, driver: driver)

      expect(driver.vehicles).to include(vehicle)
      expect(driver.vehicle_assignments.count).to eq(1)
    end

    it 'permite acessar motoristas de um veículo através de vehicle_assignments' do
      company = create(:company)
      vehicle = create(:vehicle, company: company)
      driver = create(:driver, company: company, cnpj: company.cnpj)
      create(:vehicle_assignment, vehicle: vehicle, driver: driver)

      expect(vehicle.drivers).to include(driver)
      expect(vehicle.vehicle_assignments.count).to eq(1)
    end
  end
end
