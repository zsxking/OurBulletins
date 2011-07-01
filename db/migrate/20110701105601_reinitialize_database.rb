class ReinitializeDatabase < ActiveRecord::Migration
  def change
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
    end

    add_index "listings", ["user_id"], :name => "index_listings_on_user_id"
    add_index "listings", ["saleable_id", "saleable_type"], :name => "index_listings_on_saleable"

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
end
