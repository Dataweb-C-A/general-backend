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

ActiveRecord::Schema[7.0].define(version: 2023_10_20_220248) do
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

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.string "dni"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "denominations", force: :cascade do |t|
    t.string "money"
    t.float "power"
    t.integer "quantity"
    t.string "category"
    t.string "label"
    t.float "ammount"
    t.bigint "quadre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quadre_id"], name: "index_denominations_on_quadre_id"
  end

  create_table "draws", force: :cascade do |t|
    t.string "award"
    t.string "ads"
    t.string "title"
    t.string "first_prize"
    t.string "second_prize"
    t.string "uniq"
    t.string "type_of_draw", default: ""
    t.date "init_date"
    t.date "expired_date"
    t.integer "numbers"
    t.integer "tickets_count"
    t.string "loteria"
    t.boolean "has_winners", default: false
    t.boolean "is_active", default: true
    t.integer "first_winner"
    t.integer "second_winner"
    t.integer "owner_id", null: false
    t.string "draw_type"
    t.integer "limit", default: 100
    t.float "price_unit"
    t.string "money"
    t.integer "visible_taquillas_ids", default: [], array: true
    t.integer "automatic_taquillas_ids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ticket_setted", default: 0
  end

  create_table "draws_taquillas", id: false, force: :cascade do |t|
    t.bigint "draw_id", null: false
    t.bigint "taquilla_id", null: false
    t.index ["draw_id"], name: "index_draws_taquillas_on_draw_id"
    t.index ["taquilla_id"], name: "index_draws_taquillas_on_taquilla_id"
  end

  create_table "exchanges", force: :cascade do |t|
    t.float "variacion_bs"
    t.float "variacion_cop"
    t.boolean "automatic", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inboxes", force: :cascade do |t|
    t.string "message"
    t.string "request_type"
    t.bigint "whitelist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["whitelist_id"], name: "index_inboxes_on_whitelist_id"
  end

  create_table "places", force: :cascade do |t|
    t.integer "place_numbers", default: [], array: true
    t.datetime "sold_at", default: "2023-07-17 01:18:16"
    t.integer "agency_id", null: false
    t.bigint "client_id"
    t.bigint "draw_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_places_on_client_id"
    t.index ["draw_id"], name: "index_places_on_draw_id"
  end

  create_table "printer_notifications", force: :cascade do |t|
    t.integer "tickets_generated", default: [], array: true
    t.integer "user_id", null: false
    t.boolean "is_printed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_id"
  end

  create_table "quadres", force: :cascade do |t|
    t.date "day"
    t.integer "total"
    t.float "gastos"
    t.integer "agency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.boolean "tickets_are_sold", default: false
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

  create_table "tickets", force: :cascade do |t|
    t.string "play"
    t.integer "number"
    t.integer "ticket_nro"
    t.string "serial"
    t.boolean "is_sold", default: false
    t.string "client_name"
    t.string "client_phone"
    t.datetime "sold_at"
    t.bigint "rifa_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rifa_id"], name: "index_tickets_on_rifa_id"
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
    t.string "role"
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

  create_table "whitelists", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "role"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "commission_percentage", default: 15
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "denominations", "quadres"
  add_foreign_key "inboxes", "whitelists"
  add_foreign_key "places", "clients"
  add_foreign_key "places", "draws"
  add_foreign_key "rifas", "users"
  add_foreign_key "tickets", "rifas"
  add_foreign_key "wallets", "users"
end
