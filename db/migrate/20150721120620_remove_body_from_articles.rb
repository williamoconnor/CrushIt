class RemoveBodyFromArticles < ActiveRecord::Migration
  def change
    remove_column :articles, :body, :text
  end
end
