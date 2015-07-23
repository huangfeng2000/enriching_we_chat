class ChangeWeChatAccountToWeChatNicknameInCustomers < ActiveRecord::Migration
  def change
    rename_column :customers, :we_chat_account, :we_chat_nickname
  end
end
