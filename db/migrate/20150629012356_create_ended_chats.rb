class CreateEndedChats < ActiveRecord::Migration
  def change
    create_table :ended_chats do |t|
      t.integer :expertID
      t.integer :userID
      t.integer :rating

      t.timestamps
    end
  end
end
