class CreateActiveCorrespondences < ActiveRecord::Migration
  def change
    create_table :active_correspondences do |t|
      t.string :userID
      t.string :expertID
      t.integer :refreshed

      t.timestamps
    end
  end
end
