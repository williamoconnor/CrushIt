class AddCorrespondencesToUser < ActiveRecord::Migration
  def change
    add_column :users, :correspondences, :integer
  end
end
