class AddPendingRenewalToChats < ActiveRecord::Migration
  def change
    add_column :chats, :pending_renewal, :boolean
  end
end
