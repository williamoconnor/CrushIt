class AddQualifiedExpertIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :qualified_expert_id, :integer
    remove_column :users, :qualified_expert_id, :integer
  end
end
