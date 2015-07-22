class CreateExperts < ActiveRecord::Migration
  def change
    create_table :experts do |t|
      t.string :specialty
      t.integer :rating
      t.integer :cost

      t.timestamps
    end
  end
end
