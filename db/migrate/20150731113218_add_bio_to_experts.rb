class AddBioToExperts < ActiveRecord::Migration
  def change
    add_column :experts, :bio, :text
  end
end
