# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100606194100) do

  create_table "addresses", :force => true do |t|
    t.string   "street_line_1"
    t.string   "stree_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "lat"
    t.string   "long"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "county"
    t.float    "appraised_value"
    t.string   "amount_due"
    t.string   "sale_date"
    t.boolean  "cancelled"
    t.string   "winner"
    t.string   "winning_bid"
    t.string   "plaintiff"
    t.string   "defendant"
    t.boolean  "success",         :default => false
    t.string   "case_number"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "websites", :force => true do |t|
    t.string   "webaddress"
    t.string   "parse_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
