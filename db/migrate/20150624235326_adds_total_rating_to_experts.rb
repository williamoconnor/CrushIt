class AddsTotalRatingToExperts < ActiveRecord::Migration
  def change
  	add_column :experts, :totalRatings, :integer
  end
end
