class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies, id: :uuid do |t|
      t.string :name
      t.string :cnpj

      t.timestamps
    end
    add_index :companies, :cnpj, unique: true
  end
end
