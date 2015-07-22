class FixRatingName < ActiveRecord::Migration
  def change
  	rename_column :experts, :raing, :rating
  end
end
