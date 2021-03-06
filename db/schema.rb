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

ActiveRecord::Schema[7.0].define(version: 2022_06_30_185609) do
  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "registration_number"
    t.integer "status", default: 0
    t.integer "admin_id"
    t.index ["admin_id"], name: "index_admins_on_admin_id"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "bonus_conversions", force: :cascade do |t|
    t.datetime "initial_date"
    t.datetime "final_date"
    t.integer "percentage"
    t.integer "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "deadline"
    t.index ["admin_id"], name: "index_bonus_conversions_on_admin_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.integer "discount", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bonus_conversion_id"
    t.index ["bonus_conversion_id"], name: "index_categories_on_bonus_conversion_id"
  end

  create_table "client_wallets", force: :cascade do |t|
    t.string "registered_number"
    t.string "email"
    t.integer "balance", default: 0
    t.integer "bonus_balance", default: 0
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_client_wallets_on_category_id"
  end

  create_table "credit_limits", force: :cascade do |t|
    t.integer "max_limit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credits", force: :cascade do |t|
    t.integer "value"
    t.integer "bonus_conversion_id"
    t.integer "client_wallet_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bonus_balance", default: 0
    t.index ["bonus_conversion_id"], name: "index_credits_on_bonus_conversion_id"
    t.index ["client_wallet_id"], name: "index_credits_on_client_wallet_id"
  end

  create_table "currencies", force: :cascade do |t|
    t.integer "status", default: 0
    t.float "currency_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "admin_id", null: false
    t.index ["admin_id"], name: "index_currencies_on_admin_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "value"
    t.string "registered_number"
    t.integer "status", default: 0
    t.float "currency_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cashback", default: 0
    t.text "message"
    t.string "order"
  end

  add_foreign_key "admins", "admins"
  add_foreign_key "bonus_conversions", "admins"
  add_foreign_key "categories", "bonus_conversions"
  add_foreign_key "client_wallets", "categories"
  add_foreign_key "credits", "bonus_conversions"
  add_foreign_key "credits", "client_wallets"
  add_foreign_key "currencies", "admins"
end
