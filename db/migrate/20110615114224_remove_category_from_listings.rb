class RemoveCategoryFromListings < ActiveRecord::Migration
  def self.up
    remove_column :listings, :category
  end

  def self.down
    add_column :listings, :category, :string
  end
end
