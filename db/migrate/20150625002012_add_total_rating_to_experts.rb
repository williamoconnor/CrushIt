class AddTotalRatingToExperts < ActiveRecord::Migration
  def change
    add_column :experts, :totalRating, :integer
  end
end
