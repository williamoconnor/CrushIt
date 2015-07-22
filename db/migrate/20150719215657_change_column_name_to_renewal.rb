class ChangeColumnNameToRenewal < ActiveRecord::Migration
  def change
  	rename_column :chats, :refreshed, :renewals
  end
end
