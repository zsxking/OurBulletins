class RenamePostsToListings < ActiveRecord::Migration
  def self.up
    rename_table :posts, :listings
  end

  def self.down
    rename_table :listings, :posts
  end
end
