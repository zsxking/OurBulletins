class AddClosedAtToListing < ActiveRecord::Migration
  def change
    add_column :listings, :closed_at, :datetime
  end
end
