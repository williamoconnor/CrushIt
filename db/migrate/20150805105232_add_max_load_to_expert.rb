class AddMaxLoadToExpert < ActiveRecord::Migration
  def change
    add_column :experts, :max_load, :integer
  end
end
