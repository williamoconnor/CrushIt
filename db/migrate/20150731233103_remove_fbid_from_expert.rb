class RemoveFbidFromExpert < ActiveRecord::Migration
  def change
    remove_column :experts, :fb_pic_link, :string
  end
end
