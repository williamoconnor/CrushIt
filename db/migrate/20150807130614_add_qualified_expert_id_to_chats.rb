class AddQualifiedExpertIdToChats < ActiveRecord::Migration
  def change
    add_column :experts, :featured, :boolean
  end
end
