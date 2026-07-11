# frozen_string_literal: true

class DeviseCreateDrivers < ActiveRecord::Migration[8.0]
  def change
    create_table :drivers, id: :uuid do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Atributos do Motorista (Story 34)
      t.string  :name
      t.string  :phone
      t.string  :cpf
      t.string  :cnh
      t.date    :cnh_expiration
      t.string  :cnpj,           null: false
      t.boolean :active,         default: true

      ## Invitable (Story 33)
      t.string   :invitation_token
      t.datetime :invitation_created_at
      t.datetime :invitation_sent_at
      t.datetime :invitation_accepted_at
      t.integer  :invitation_limit
      t.references :invited_by, polymorphic: true, index: true
      t.integer  :invitations_count, default: 0

      t.timestamps null: false
    end

    add_index :drivers, :email,                unique: true
    add_index :drivers, :reset_password_token, unique: true
    add_index :drivers, :invitation_token,     unique: true
    add_index :drivers, :cnpj
    add_index :drivers, :cpf,                  unique: true
    add_index :drivers, :cnh,                  unique: true
  end
end
