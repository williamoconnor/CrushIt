class ChangeUsersColumnNames < ActiveRecord::Migration
  def change
  	change_table :users do |t|
  		t.rename :qbID, :qb_id
  		t.rename :expertID, :expert_id
  		t.rename :sharedToFB, :shared_to_fb
  	end
  end
end
