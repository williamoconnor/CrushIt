class AddPhotoFilePathToExpert < ActiveRecord::Migration
  def change
    add_column :experts, :photo_file_path, :string
  end
end
