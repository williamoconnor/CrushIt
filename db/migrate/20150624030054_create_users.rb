class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :age
      t.string :gender
      t.string :interest
      t.string :password
      t.string :qbID
      t.string :expertID

      t.timestamps
    end
  end
end
