# frozen_string_literal: true

class CreateVehicleAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :vehicle_assignments, id: :uuid do |t|
      t.references :vehicle, type: :uuid, null: false, foreign_key: true
      t.references :driver, type: :uuid, null: false, foreign_key: true
      t.datetime :assigned_at, null: false
      t.datetime :unassigned_at

      t.timestamps
    end
  end
end
