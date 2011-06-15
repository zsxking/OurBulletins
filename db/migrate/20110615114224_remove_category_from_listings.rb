class RemoveCategoryFromListings < ActiveRecord::Migration
  def self.up
    remove_column :listings, :category
  end

  def self.down
  end
end
