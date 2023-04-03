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

ActiveRecord::Schema[7.0].define(version: 2023_04_03_071825) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "rifa_tickets", force: :cascade do |t|
    t.string "sign"
    t.integer "number"
    t.integer "ticket_nro"
    t.string "serial"
    t.boolean "is_sold"
    t.string "sold_at"
    t.bigint "rifa_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rifa_id"], name: "index_rifa_tickets_on_rifa_id"
  end

  create_table "rifas", force: :cascade do |t|
    t.string "awardSign"
    t.string "awardNoSign"
    t.boolean "is_send"
    t.date "rifDate"
    t.date "expired"
    t.string "money"
    t.string "loteria", null: false
    t.float "price"
    t.string "pin"
    t.string "serial"
    t.boolean "verify"
    t.string "plate"
    t.integer "numbers"
    t.string "tickets_type"
    t.integer "year"
    t.integer "taquillas_ids", default: [], array: true
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_rifas_on_user_id"
  end

  create_table "rifas_taquillas", id: false, force: :cascade do |t|
    t.bigint "rifa_id", null: false
    t.bigint "taquilla_id", null: false
    t.index ["rifa_id"], name: "index_rifas_taquillas_on_rifa_id"
    t.index ["taquilla_id"], name: "index_rifas_taquillas_on_taquilla_id"
  end

  create_table "taquillas", force: :cascade do |t|
    t.string "name"
    t.string "apikey"
    t.string "system", default: "Rifamax"
    t.integer "owner_id", null: false
    t.integer "users_ids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_taquillas_on_owner_id"
    t.index ["users_ids"], name: "index_taquillas_on_users_ids", using: :gin
  end

  create_table "taquillas_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "taquilla_id", null: false
    t.index ["taquilla_id"], name: "index_taquillas_users_on_taquilla_id"
    t.index ["user_id"], name: "index_taquillas_users_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "reason"
    t.string "transaction_type"
    t.string "reference"
    t.float "amount"
    t.string "status"
    t.integer "sender_wallet_id", null: false
    t.integer "receiver_wallet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar"
    t.string "name"
    t.string "username"
    t.string "cedula"
    t.string "email"
    t.string "phone"
    t.string "password_digest"
    t.datetime "deleted_at"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cedula"], name: "index_users_on_cedula", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.float "balance", default: 0.0
    t.float "debt", default: 0.0
    t.float "debt_limit", default: 0.0
    t.float "balance_limit", default: 10000.0
    t.string "api_key"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "rifa_tickets", "rifas"
  add_foreign_key "rifas", "users"
  add_foreign_key "wallets", "users"
end
