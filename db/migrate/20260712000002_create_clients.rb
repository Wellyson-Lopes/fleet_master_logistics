# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.string :document
      t.string :email
      t.string :phone
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :status, default: 'active', null: false
      t.text :notes

      t.timestamps
    end

    add_index :clients, %i[company_id document]
    add_index :clients, %i[company_id name]
  end
end
