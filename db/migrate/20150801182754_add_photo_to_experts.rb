class AddPhotoToExperts < ActiveRecord::Migration
  def up
    add_attachment :experts, :avatar
  end

  def down
    remove_attachment :experts, :avatar
  end
end
