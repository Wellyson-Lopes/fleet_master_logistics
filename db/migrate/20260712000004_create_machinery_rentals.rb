# frozen_string_literal: true

class CreateMachineryRentals < ActiveRecord::Migration[8.0]
  def change
    create_table :machinery_rentals, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.references :machinery, null: false, foreign_key: true, type: :uuid
      t.references :client, null: false, foreign_key: true, type: :uuid
      t.string :code, null: false
      t.string :rental_type, default: 'daily', null: false # 'hourly' ou 'daily'
      t.decimal :duration, precision: 10, scale: 2, default: 1.0, null: false
      t.decimal :rate_applied, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :total_amount, precision: 10, scale: 2, default: 0.0, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date
      t.string :status, default: 'active', null: false # 'active', 'completed', 'canceled'
      t.string :delivery_address
      t.text :notes

      t.timestamps
    end

    add_index :machinery_rentals, %i[company_id code], unique: true
    add_index :machinery_rentals, %i[company_id status]
  end
end
