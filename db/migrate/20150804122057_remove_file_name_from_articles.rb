class RemoveFileNameFromArticles < ActiveRecord::Migration
  def change
    remove_column :articles, :file_path, :string
  end
end
