# frozen_string_literal: true

class CreateDriverNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :driver_notifications, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.references :driver, null: false, foreign_key: true, type: :uuid
      t.string :title, null: false
      t.text :message, null: false
      t.string :notification_type, null: false
      t.boolean :read, default: false, null: false
      t.datetime :read_at
      t.string :notifiable_type
      t.uuid :notifiable_id

      t.timestamps
    end

    add_index :driver_notifications, %i[driver_id read]
    add_index :driver_notifications, %i[notifiable_type notifiable_id]
  end
end
