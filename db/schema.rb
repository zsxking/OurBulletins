# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110812172742) do

  create_table "books", :force => true do |t|
    t.string   "ean"
    t.string   "isbn"
    t.string   "title"
    t.string   "author"
    t.string   "publisher"
    t.string   "edition"
    t.string   "publish_date"
    t.decimal  "list_price",        :precision => 8, :scale => 2
    t.text     "description"
    t.string   "image_link"
    t.string   "amazon_detail_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_link"
  end

  add_index "books", ["ean"], :name => "index_books_on_ean", :unique => true
  add_index "books", ["isbn"], :name => "index_books_on_isbn", :unique => true

  create_table "listings", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price",         :precision => 8, :scale => 2
    t.integer  "saleable_id"
    t.string   "saleable_type"
    t.string   "condition"
    t.datetime "closed_at"
  end

  add_index "listings", ["saleable_id", "saleable_type"], :name => "index_listings_on_saleable"
  add_index "listings", ["user_id"], :name => "index_listings_on_user_id"

  create_table "replies", :force => true do |t|
    t.integer  "listing_id"
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "replies", ["listing_id", "user_id"], :name => "index_users_on_listing_and_user_unique", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                       :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
