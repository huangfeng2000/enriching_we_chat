class RenameOpenIdToWeChatOpenidInCustomers < ActiveRecord::Migration
  def change
    rename_column :customers, :open_id, :we_chat_openid
  end
end
