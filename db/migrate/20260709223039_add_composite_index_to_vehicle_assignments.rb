# frozen_string_literal: true

class AddCompositeIndexToVehicleAssignments < ActiveRecord::Migration[8.0]
  def change
    add_index :vehicle_assignments, %i[vehicle_id driver_id assigned_at],
              name: 'idx_vehicle_assignments_on_vehicle_driver_assigned'
  end
end
