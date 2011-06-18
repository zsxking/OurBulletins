class AddPriceToListing < ActiveRecord::Migration
  def self.up
    add_column :listings, :price, :decimal, :precision => 8, :scale => 2,
               :after => :title
  end

  def self.down
    remove_column :listings, :price
  end
end
