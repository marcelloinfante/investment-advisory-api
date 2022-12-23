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

ActiveRecord::Schema[7.0].define(version: 2022_12_21_203357) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", force: :cascade do |t|
    t.string "code"
    t.string "issuer"
    t.string "rate_index"
    t.decimal "entrance_rate"
    t.integer "quantity"
    t.datetime "application_date"
    t.datetime "expiration_date"
    t.datetime "discarded_at"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_assets_on_client_id"
    t.index ["discarded_at"], name: "index_assets_on_discarded_at"
  end

  create_table "clients", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "discarded_at"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_clients_on_discarded_at"
    t.index ["email"], name: "index_clients_on_email"
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_companies_on_discarded_at"
  end

  create_table "simulations", force: :cascade do |t|
    t.string "new_asset_code"
    t.string "new_asset_issuer"
    t.datetime "new_asset_expiration_date"
    t.decimal "new_asset_minimum_rate"
    t.decimal "new_asset_maximum_rate"
    t.integer "new_asset_duration"
    t.decimal "new_asset_indicative_rate"
    t.decimal "new_asset_suggested_rate"
    t.datetime "quotation_date"
    t.integer "days_in_years"
    t.decimal "remaining_years"
    t.decimal "average_cdi"
    t.integer "volume_applied"
    t.integer "curve_volume"
    t.integer "market_redemption"
    t.decimal "market_rate"
    t.decimal "new_asset_remaining_years"
    t.integer "agio"
    t.decimal "agio_percentage"
    t.decimal "percentage_to_recover"
    t.decimal "current_final_value"
    t.decimal "new_rate_final_value_same_period"
    t.decimal "variation_same_period"
    t.decimal "new_rate_final_value_new_period"
    t.decimal "final_variation"
    t.boolean "is_worth"
    t.datetime "discarded_at"
    t.bigint "asset_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_simulations_on_asset_id"
    t.index ["discarded_at"], name: "index_simulations_on_discarded_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.string "recovery_password_digest"
    t.datetime "discarded_at"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "assets", "clients"
  add_foreign_key "clients", "users"
  add_foreign_key "simulations", "assets"
  add_foreign_key "users", "companies"
end
