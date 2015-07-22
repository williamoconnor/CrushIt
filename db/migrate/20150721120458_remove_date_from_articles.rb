class RemoveDateFromArticles < ActiveRecord::Migration
  def change
    remove_column :articles, :date, :datetime
  end
end
