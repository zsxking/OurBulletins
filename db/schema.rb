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

ActiveRecord::Schema.define(:version => 20110611084017) do

  create_table "books", :force => true do |t|
    t.string   "ean"
    t.string   "isbn"
    t.string   "title"
    t.string   "author"
    t.string   "publisher"
    t.string   "edition"
    t.string   "publish_date"
    t.integer  "list_price"
    t.text     "description"
    t.string   "image_link"
    t.string   "amazon_detail_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "books", ["ean"], :name => "index_books_on_ean", :unique => true
  add_index "books", ["isbn"], :name => "index_books_on_isbn", :unique => true

  create_table "listings", :force => true do |t|
    t.string   "title"
    t.string   "category"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "encrypted_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.integer  "status",             :default => 0,     :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
