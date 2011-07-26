class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.references :listing
      t.references :user
      t.text :message

      t.timestamps
    end

    add_index :replies, [:listing_id, :user_id], :name => "index_users_on_listing_and_user_unique", :unique => true
  end
end
