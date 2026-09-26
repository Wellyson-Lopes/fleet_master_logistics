# frozen_string_literal: true

class CreateTripStatusUpdatesAndFuelRefuelsAndNotifications < ActiveRecord::Migration[8.0]
  def change
    # 1. Histórico de atualização de status da viagem com motivo e localização
    create_table :trip_status_updates, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.uuid :company_id, null: false
      t.uuid :trip_id, null: false
      t.uuid :driver_id, null: false
      t.string :status, null: false
      t.string :reason
      t.text :notes
      t.decimal :latitude, precision: 10, scale: 7
      t.decimal :longitude, precision: 10, scale: 7

      t.timestamps
    end

    add_index :trip_status_updates, :company_id
    add_index :trip_status_updates, :trip_id
    add_index :trip_status_updates, :driver_id
    add_foreign_key :trip_status_updates, :companies
    add_foreign_key :trip_status_updates, :trips
    add_foreign_key :trip_status_updates, :drivers

    # 2. Registro de Abastecimento
    create_table :fuel_refuels, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.uuid :company_id, null: false
      t.uuid :vehicle_id, null: false
      t.uuid :driver_id, null: false
      t.integer :current_mileage_km, null: false
      t.decimal :liters, precision: 10, scale: 2, null: false
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.string :fuel_type, default: 'diesel_s10', null: false
      t.text :notes

      t.timestamps
    end

    add_index :fuel_refuels, :company_id
    add_index :fuel_refuels, :vehicle_id
    add_index :fuel_refuels, :driver_id
    add_foreign_key :fuel_refuels, :companies
    add_foreign_key :fuel_refuels, :vehicles
    add_foreign_key :fuel_refuels, :drivers

    # 3. Notificações do sistema Web (sininho para secretários/admins)
    create_table :notifications, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.uuid :company_id, null: false
      t.bigint :user_id
      t.string :title, null: false
      t.text :message, null: false
      t.string :notification_type, null: false
      t.boolean :read, default: false, null: false
      t.datetime :read_at
      t.string :notifiable_type
      t.uuid :notifiable_id

      t.timestamps
    end

    add_index :notifications, :company_id
    add_index :notifications, :user_id
    add_index :notifications, %i[company_id read]
    add_index :notifications, %i[notifiable_type notifiable_id]
    add_foreign_key :notifications, :companies
    add_foreign_key :notifications, :users

    # 4. Aprimoramentos em drivers
    add_column :drivers, :invitation_code_expires_at, :datetime
    add_column :drivers, :fingerprint_enabled, :boolean, default: false, null: false

    # 5. Aprimoramentos em trips
    add_column :trips, :client_id, :uuid
    add_column :trips, :status_reason, :string
    add_index :trips, :client_id
    add_foreign_key :trips, :clients

    # 6. Aprimoramentos em vehicles (documentação CRLV)
    add_column :vehicles, :crlv_number, :string
    add_column :vehicles, :crlv_expiration, :date
    add_index :vehicles, :crlv_expiration
  end
end
