ActiveRecord::Schema.define(version: 2020_12_14_022657) do

  create_table "cryptos", force: :cascade do |t|
    t.string "symbol"
    t.integer "user_id"
    t.decimal "cost_per"
    t.decimal "amount_owned"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_cryptos_on_user_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer "user_id"
    t.string "symbol"
    t.decimal "cost_per"
    t.decimal "amount"
    t.decimal "fee"
    t.decimal "total_cost"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "crypto_id", null: false
    t.index ["crypto_id"], name: "index_purchases_on_crypto_id"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "purchases", "cryptos"
end
