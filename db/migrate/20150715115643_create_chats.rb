class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :userID
      t.integer :expertID
      t.integer :refreshed
      t.integer :rating
      t.boolean :active

      t.timestamps
    end
  end
end
