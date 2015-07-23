class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :we_chat_account
      t.string :open_id
      t.string :tel_no

      t.timestamps
    end
  end
end
