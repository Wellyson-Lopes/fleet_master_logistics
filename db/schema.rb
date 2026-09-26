# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_07_12_000008) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "asaas_charges", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.uuid "client_id"
    t.string "asaas_id"
    t.string "customer_id"
    t.string "billing_type", null: false
    t.decimal "value", precision: 10, scale: 2, null: false
    t.decimal "net_value", precision: 10, scale: 2
    t.string "status", default: "PENDING", null: false
    t.date "due_date", null: false
    t.datetime "payment_date"
    t.string "invoice_url"
    t.string "bank_slip_url"
    t.text "pix_qr_code"
    t.text "pix_copy_paste"
    t.string "description"
    t.string "payable_type"
    t.uuid "payable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asaas_id"], name: "index_asaas_charges_on_asaas_id", unique: true
    t.index ["client_id"], name: "index_asaas_charges_on_client_id"
    t.index ["company_id", "status"], name: "index_asaas_charges_on_company_id_and_status"
    t.index ["company_id"], name: "index_asaas_charges_on_company_id"
    t.index ["payable_type", "payable_id"], name: "index_asaas_charges_on_payable_type_and_payable_id"
  end

  create_table "clients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.string "name", null: false
    t.string "document"
    t.string "email"
    t.string "phone"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "status", default: "active", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "document"], name: "index_clients_on_company_id_and_document"
    t.index ["company_id", "name"], name: "index_clients_on_company_id_and_name"
    t.index ["company_id"], name: "index_clients_on_company_id"
  end

  create_table "companies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "plan", default: "starter", null: false
    t.string "billing_cycle", default: "monthly", null: false
    t.string "subscription_status", default: "trialing", null: false
    t.datetime "trial_ends_at"
    t.index ["cnpj"], name: "index_companies_on_cnpj", unique: true
  end

  create_table "driver_locations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.uuid "driver_id", null: false
    t.uuid "trip_id"
    t.decimal "latitude", precision: 10, scale: 7, null: false
    t.decimal "longitude", precision: 10, scale: 7, null: false
    t.decimal "speed", precision: 6, scale: 2
    t.decimal "heading", precision: 6, scale: 2
    t.datetime "recorded_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_driver_locations_on_company_id"
    t.index ["driver_id", "recorded_at"], name: "index_driver_locations_on_driver_id_and_recorded_at"
    t.index ["driver_id"], name: "index_driver_locations_on_driver_id"
    t.index ["trip_id", "recorded_at"], name: "index_driver_locations_on_trip_id_and_recorded_at"
    t.index ["trip_id"], name: "index_driver_locations_on_trip_id"
  end

  create_table "driver_notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.uuid "driver_id", null: false
    t.string "title", null: false
    t.text "message", null: false
    t.string "notification_type", null: false
    t.boolean "read", default: false, null: false
    t.datetime "read_at"
    t.string "notifiable_type"
    t.uuid "notifiable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_driver_notifications_on_company_id"
    t.index ["driver_id", "read"], name: "index_driver_notifications_on_driver_id_and_read"
    t.index ["driver_id"], name: "index_driver_notifications_on_driver_id"
    t.index ["notifiable_type", "notifiable_id"], name: "idx_on_notifiable_type_notifiable_id_2669f102f6"
  end

  create_table "drivers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name"
    t.string "phone"
    t.string "cpf"
    t.string "cnh"
    t.date "cnh_expiration"
    t.string "cnpj", null: false
    t.boolean "active", default: true
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "company_id"
    t.string "invitation_code"
    t.datetime "invitation_code_sent_at"
    t.decimal "current_latitude", precision: 10, scale: 7
    t.decimal "current_longitude", precision: 10, scale: 7
    t.datetime "last_location_at"
    t.datetime "invitation_code_expires_at"
    t.boolean "fingerprint_enabled", default: false, null: false
    t.index ["cnh"], name: "index_drivers_on_cnh", unique: true
    t.index ["cnpj"], name: "index_drivers_on_cnpj"
    t.index ["company_id"], name: "index_drivers_on_company_id"
    t.index ["cpf"], name: "index_drivers_on_cpf", unique: true
    t.index ["email"], name: "index_drivers_on_email", unique: true
    t.index ["invitation_code"], name: "index_drivers_on_invitation_code"
    t.index ["invitation_token"], name: "index_drivers_on_invitation_token", unique: true
    t.index ["invited_by_type", "invited_by_id"], name: "index_drivers_on_invited_by"
    t.index ["reset_password_token"], name: "index_drivers_on_reset_password_token", unique: true
  end

  create_table "fuel_refuels", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.uuid "vehicle_id", null: false
    t.uuid "driver_id", null: false
    t.integer "current_mileage_km", null: false
    t.decimal "liters", precision: 10, scale: 2, null: false
    t.decimal "total_amount", precision: 10, scale: 2, null: false
    t.string "fuel_type", default: "diesel_s10", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_fuel_refuels_on_company_id"
    t.index ["driver_id"], name: "index_fuel_refuels_on_driver_id"
    t.index ["vehicle_id"], name: "index_fuel_refuels_on_vehicle_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti"
    t.datetime "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "machineries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.string "name", null: false
    t.string "category", null: false
    t.string "brand"
    t.string "model"
    t.integer "year"
    t.string "serial_number"
    t.decimal "hourly_rate", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "daily_rate", precision: 10, scale: 2, default: "0.0", null: false
    t.string "status", default: "available", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "category"], name: "index_machineries_on_company_id_and_category"
    t.index ["company_id", "status"], name: "index_machineries_on_company_id_and_status"
    t.index ["company_id"], name: "index_machineries_on_company_id"
  end

  create_table "machinery_rentals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.uuid "machinery_id", null: false
    t.uuid "client_id", null: false
    t.string "code", null: false
    t.string "rental_type", default: "daily", null: false
    t.decimal "duration", precision: 10, scale: 2, default: "1.0", null: false
    t.decimal "rate_applied", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date"
    t.string "status", default: "active", null: false
    t.string "delivery_address"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_machinery_rentals_on_client_id"
    t.index ["company_id", "code"], name: "index_machinery_rentals_on_company_id_and_code", unique: true
    t.index ["company_id", "status"], name: "index_machinery_rentals_on_company_id_and_status"
    t.index ["company_id"], name: "index_machinery_rentals_on_company_id"
    t.index ["machinery_id"], name: "index_machinery_rentals_on_machinery_id"
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.bigint "user_id"
    t.string "title", null: false
    t.text "message", null: false
    t.string "notification_type", null: false
    t.boolean "read", default: false, null: false
    t.datetime "read_at"
    t.string "notifiable_type"
    t.uuid "notifiable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "read"], name: "index_notifications_on_company_id_and_read"
    t.index ["company_id"], name: "index_notifications_on_company_id"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "trip_status_updates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.uuid "trip_id", null: false
    t.uuid "driver_id", null: false
    t.string "status", null: false
    t.string "reason"
    t.text "notes"
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_trip_status_updates_on_company_id"
    t.index ["driver_id"], name: "index_trip_status_updates_on_driver_id"
    t.index ["trip_id"], name: "index_trip_status_updates_on_trip_id"
  end

  create_table "trips", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.uuid "vehicle_id", null: false
    t.uuid "driver_id", null: false
    t.string "code", null: false
    t.string "origin", null: false
    t.string "destination", null: false
    t.string "client_name", null: false
    t.string "cargo_description", null: false
    t.integer "cargo_weight_kg", default: 0, null: false
    t.decimal "freight_value", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "distance_km"
    t.string "status", default: "scheduled", null: false
    t.datetime "started_at"
    t.datetime "delivered_at"
    t.datetime "estimated_delivery_at"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "client_id"
    t.string "status_reason"
    t.index ["client_id"], name: "index_trips_on_client_id"
    t.index ["company_id", "code"], name: "index_trips_on_company_id_and_code", unique: true
    t.index ["company_id"], name: "index_trips_on_company_id"
    t.index ["driver_id"], name: "index_trips_on_driver_id"
    t.index ["status"], name: "index_trips_on_status"
    t.index ["vehicle_id"], name: "index_trips_on_vehicle_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "cnpj"
    t.string "company_name"
    t.boolean "admin", default: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "company_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicle_assignments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "vehicle_id", null: false
    t.uuid "driver_id", null: false
    t.datetime "assigned_at", null: false
    t.datetime "unassigned_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_vehicle_assignments_on_driver_id"
    t.index ["vehicle_id", "driver_id", "assigned_at"], name: "idx_vehicle_assignments_on_vehicle_driver_assigned"
    t.index ["vehicle_id"], name: "index_vehicle_assignments_on_vehicle_id"
  end

  create_table "vehicles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type", null: false
    t.string "plate", null: false
    t.string "brand"
    t.string "model"
    t.integer "year"
    t.integer "load_capacity_kg"
    t.integer "current_mileage_km"
    t.string "status", default: "active"
    t.string "chassis"
    t.string "renavam"
    t.uuid "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "crlv_number"
    t.date "crlv_expiration"
    t.index ["company_id"], name: "index_vehicles_on_company_id"
    t.index ["crlv_expiration"], name: "index_vehicles_on_crlv_expiration"
    t.index ["plate"], name: "index_vehicles_on_plate", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "asaas_charges", "clients"
  add_foreign_key "asaas_charges", "companies"
  add_foreign_key "clients", "companies"
  add_foreign_key "driver_locations", "companies"
  add_foreign_key "driver_locations", "drivers"
  add_foreign_key "driver_locations", "trips"
  add_foreign_key "driver_notifications", "companies"
  add_foreign_key "driver_notifications", "drivers"
  add_foreign_key "drivers", "companies"
  add_foreign_key "fuel_refuels", "companies"
  add_foreign_key "fuel_refuels", "drivers"
  add_foreign_key "fuel_refuels", "vehicles"
  add_foreign_key "machineries", "companies"
  add_foreign_key "machinery_rentals", "clients"
  add_foreign_key "machinery_rentals", "companies"
  add_foreign_key "machinery_rentals", "machineries"
  add_foreign_key "notifications", "companies"
  add_foreign_key "notifications", "users"
  add_foreign_key "trip_status_updates", "companies"
  add_foreign_key "trip_status_updates", "drivers"
  add_foreign_key "trip_status_updates", "trips"
  add_foreign_key "trips", "clients"
  add_foreign_key "trips", "companies"
  add_foreign_key "trips", "drivers"
  add_foreign_key "trips", "vehicles"
  add_foreign_key "users", "companies"
  add_foreign_key "vehicle_assignments", "drivers"
  add_foreign_key "vehicle_assignments", "vehicles"
  add_foreign_key "vehicles", "companies"
end
