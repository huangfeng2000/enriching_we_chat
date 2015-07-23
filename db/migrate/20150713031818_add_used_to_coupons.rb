class AddUsedToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :used, :boolean
  end
end
