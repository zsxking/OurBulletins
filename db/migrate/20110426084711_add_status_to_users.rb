class AddStatusToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :status, :integer,
               :default => 0, :null => false, :after => :salt
  end

  def self.down
    remove_column :users, :status
  end
end
