# frozen_string_literal: true

class CreateMachineries < ActiveRecord::Migration[8.0]
  def change
    create_table :machineries, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.string :category, null: false
      t.string :brand
      t.string :model
      t.integer :year
      t.string :serial_number
      t.decimal :hourly_rate, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :daily_rate, precision: 10, scale: 2, default: 0.0, null: false
      t.string :status, default: 'available', null: false
      t.text :notes

      t.timestamps
    end

    add_index :machineries, %i[company_id status]
    add_index :machineries, %i[company_id category]
  end
end
