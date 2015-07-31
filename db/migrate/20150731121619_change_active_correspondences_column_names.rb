class ChangeActiveCorrespondencesColumnNames < ActiveRecord::Migration
  def change
  	change_table :active_correspondences do |t|
  		t.rename :userID, :user_id
  		t.rename :expertID, :expert_id
  	end
  end
end
