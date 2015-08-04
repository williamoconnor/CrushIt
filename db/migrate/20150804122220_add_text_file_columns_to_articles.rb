class AddTextFileColumnsToArticles < ActiveRecord::Migration
  def up
    add_attachment :articles, :text_file
  end

  def down
    remove_attachment :articles, :text_file
  end
end
