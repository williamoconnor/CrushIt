class AddQbCodeToUser < ActiveRecord::Migration
  def change
  	add_column :users, :qb_code, :string
  end
end
