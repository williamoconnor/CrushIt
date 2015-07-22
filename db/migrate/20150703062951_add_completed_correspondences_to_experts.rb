class AddCompletedCorrespondencesToExperts < ActiveRecord::Migration
  def change
    	add_column :experts, :correspondences, :integer
  end
end
