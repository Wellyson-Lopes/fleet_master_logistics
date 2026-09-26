# frozen_string_literal: true

class CreateAsaasCharges < ActiveRecord::Migration[8.0]
  def change
    create_table :asaas_charges, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.references :client, foreign_key: true, type: :uuid
      t.string :asaas_id
      t.string :customer_id
      t.string :billing_type, null: false # 'PIX', 'BOLETO', 'CREDIT_CARD'
      t.decimal :value, precision: 10, scale: 2, null: false
      t.decimal :net_value, precision: 10, scale: 2
      t.string :status, default: 'PENDING', null: false # PENDING, RECEIVED, CONFIRMED, OVERDUE, REFUNDED
      t.date :due_date, null: false
      t.datetime :payment_date
      t.string :invoice_url
      t.string :bank_slip_url
      t.text :pix_qr_code
      t.text :pix_copy_paste
      t.string :description
      t.string :payable_type
      t.uuid :payable_id

      t.timestamps
    end

    add_index :asaas_charges, :asaas_id, unique: true
    add_index :asaas_charges, %i[company_id status]
    add_index :asaas_charges, %i[payable_type payable_id]
  end
end
