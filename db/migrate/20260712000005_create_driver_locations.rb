# frozen_string_literal: true

class CreateDriverLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :driver_locations, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.references :driver, null: false, foreign_key: true, type: :uuid
      t.references :trip, foreign_key: true, type: :uuid
      t.decimal :latitude, precision: 10, scale: 7, null: false
      t.decimal :longitude, precision: 10, scale: 7, null: false
      t.decimal :speed, precision: 6, scale: 2
      t.decimal :heading, precision: 6, scale: 2
      t.datetime :recorded_at, null: false

      t.timestamps
    end

    add_index :driver_locations, %i[driver_id recorded_at]
    add_index :driver_locations, %i[trip_id recorded_at]
  end
end
