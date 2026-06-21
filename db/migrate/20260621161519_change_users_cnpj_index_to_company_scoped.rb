class ChangeUsersCnpjIndexToCompanyScoped < ActiveRecord::Migration[8.0]
  def change
    remove_index :users, column: :cnpj, unique: true
  end
end
