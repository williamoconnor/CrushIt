class AddFilePathToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :file_path, :string
  end
end
