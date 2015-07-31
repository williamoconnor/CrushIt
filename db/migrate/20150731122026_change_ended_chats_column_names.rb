class ChangeEndedChatsColumnNames < ActiveRecord::Migration
  def change
  	change_table :ended_chats do |t|
  		t.rename :userID, :user_id
  		t.rename :expertID, :expert_id
  	end
  end
end
