# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Driver, type: :model do
  let(:valid_attributes) do
    {
      name: 'João Silva',
      email: 'joao@driver.com',
      password: 'password123',
      cnpj: '12345678000195',
      cpf: '123.456.789-00',
      cnh: '123456789',
      cnh_expiration: 1.year.from_now
    }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      allow(CPF).to receive(:valid?).and_return(true)
      allow(CNPJ).to receive(:valid?).and_return(true)

      driver = Driver.new(valid_attributes)
      expect(driver).to be_valid
    end

    it 'is invalid without a cnpj' do
      driver = Driver.new(cnpj: nil)
      driver.valid?
      expect(driver.errors[:cnpj]).to include('não pode ficar em branco')
    end

    it 'is invalid with an invalid CPF' do
      allow(CPF).to receive(:valid?).and_return(false)
      driver = Driver.new(cpf: '123')
      driver.valid?
      expect(driver.errors[:cpf]).to include('não é válido')
    end

    it 'is invalid with an invalid CNPJ' do
      allow(CNPJ).to receive(:valid?).and_return(false)
      driver = Driver.new(cnpj: '123')
      driver.valid?
      expect(driver.errors[:cnpj]).to include('não é válido')
    end
  end

  describe 'associations' do
    it 'can have an avatar' do
      driver = Driver.new
      expect(driver.avatar).to be_an_instance_of(ActiveStorage::Attached::One)
    end
  end
end
