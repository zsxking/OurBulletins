class AddPriceToListing < ActiveRecord::Migration
  def self.up
    add_column :listings, :price, :integer,
               :after => :category
    change_column :books, :list_price, :integer
  end

  def self.down
    remove_column :listings, :price
    change_column :books, :list_price, :decimal, :precision => 8, :scale => 2
  end
end
