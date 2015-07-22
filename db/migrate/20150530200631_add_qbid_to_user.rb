class AddQbidToUser < ActiveRecord::Migration
  def change
    add_column :users, :qbID, :string
  end
end
