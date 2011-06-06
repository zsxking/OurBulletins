class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string :ean, :length => 13
      t.string :isbn, :length => 13
      t.string :title
      t.string :author
      t.string :publisher
      t.string :edition
      t.string :publish_date
      t.decimal :list_price, :precision => 8, :scale => 2
      t.text :description
      t.string :image_link
      t.string :amazon_detail_url

      t.timestamps
    end
    add_index :books, :isbn, :unique => true
    add_index :books, :ean, :unique => true
  end

  def self.down
    drop_table :books
  end
end
