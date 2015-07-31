class ChangeExpertsColumnNames < ActiveRecord::Migration
  def change
  	change_table :experts do |t|
  		t.rename :totalRating, :total_rating
  	end
  end
end
