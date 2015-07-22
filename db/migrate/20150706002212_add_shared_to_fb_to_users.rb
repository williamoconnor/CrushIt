class AddSharedToFbToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sharedToFB, :boolean
  end
end
