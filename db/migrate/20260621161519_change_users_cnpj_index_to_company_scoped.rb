class ChangeUsersCnpjIndexToCompanyScoped < ActiveRecord::Migration[8.0]
  def change
    remove_index :users, column: :cnpj, unique: true
    add_index :users, [:cnpj, :company_id], unique: true
  end
end
