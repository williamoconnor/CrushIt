class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.integer :age
      t.string :gender
      t.string :interest

      t.timestamps
    end
  end
end
