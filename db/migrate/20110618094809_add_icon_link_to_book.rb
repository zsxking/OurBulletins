class AddIconLinkToBook < ActiveRecord::Migration
  def self.up
    add_column :books, :icon_link, :string
  end

  def self.down
    remove_column :books, :icon_link
  end
end
