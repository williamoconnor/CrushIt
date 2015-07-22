class AddSpecialtiesToExperts < ActiveRecord::Migration
  def change
  	add_column :experts, :specialty2, :string
  	add_column :experts, :specialty3, :string
  	add_column :experts, :specialty4, :string
  end
end
