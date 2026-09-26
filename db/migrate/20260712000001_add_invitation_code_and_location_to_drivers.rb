# frozen_string_literal: true

class AddInvitationCodeAndLocationToDrivers < ActiveRecord::Migration[8.0]
  def change
    add_column :drivers, :invitation_code, :string
    add_column :drivers, :invitation_code_sent_at, :datetime
    add_column :drivers, :current_latitude, :decimal, precision: 10, scale: 7
    add_column :drivers, :current_longitude, :decimal, precision: 10, scale: 7
    add_column :drivers, :last_location_at, :datetime

    add_index :drivers, :invitation_code
  end
end
