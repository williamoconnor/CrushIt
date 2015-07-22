class AddAvailabilityToExperts < ActiveRecord::Migration
  def change
    add_column :experts, :availability, :boolean
  end
end
