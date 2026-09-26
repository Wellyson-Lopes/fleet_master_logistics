# frozen_string_literal: true

class CreateTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :trips, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid :company_id, null: false
      t.uuid :vehicle_id, null: false
      t.uuid :driver_id, null: false

      t.string :code, null: false
      t.string :origin, null: false
      t.string :destination, null: false
      t.string :client_name, null: false
      t.string :cargo_description, null: false
      t.integer :cargo_weight_kg, null: false, default: 0
      t.decimal :freight_value, precision: 10, scale: 2, default: 0.0, null: false
      t.integer :distance_km
      t.string :status, default: "scheduled", null: false
      t.datetime :started_at
      t.datetime :delivered_at
      t.datetime :estimated_delivery_at
      t.text :notes

      t.timestamps
    end

    add_index :trips, :company_id
    add_index :trips, :vehicle_id
    add_index :trips, :driver_id
    add_index :trips, %i[company_id code], unique: true
    add_index :trips, :status

    add_foreign_key :trips, :companies
    add_foreign_key :trips, :vehicles
    add_foreign_key :trips, :drivers
  end
end
