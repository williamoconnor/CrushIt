class AddExpertIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :expertID, :integer
  end
end
