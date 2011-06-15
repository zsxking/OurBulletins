class AddListingsToBooks < ActiveRecord::Migration
  def self.up
    change_table :listings do |t|
      t.references :saleable, :polymorphic => true
    end
  end

  def self.down
    remove_column :listings, :saleable_id
    remove_column :listings, :saleable_type
  end
end
