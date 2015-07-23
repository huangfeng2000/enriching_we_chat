class AddDeleteFlagToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :delete_flag, :boolean
  end
end
