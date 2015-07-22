class AddFbPicLinkToExpert < ActiveRecord::Migration
  def change
    add_column :experts, :fb_pic_link, :string
  end
end
