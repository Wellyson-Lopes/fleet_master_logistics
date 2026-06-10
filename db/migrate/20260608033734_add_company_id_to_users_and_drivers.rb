class AddCompanyIdToUsersAndDrivers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :company_id, :uuid
    add_column :drivers, :company_id, :uuid
    
    add_index :users, :company_id
    add_index :drivers, :company_id

    add_foreign_key :users, :companies
    add_foreign_key :drivers, :companies
  end
end
