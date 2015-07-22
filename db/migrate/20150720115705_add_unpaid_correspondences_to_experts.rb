class AddUnpaidCorrespondencesToExperts < ActiveRecord::Migration
  def change
    add_column :experts, :unpaid_correspondences, :integer
  end
end
