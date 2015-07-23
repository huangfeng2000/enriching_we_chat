class AddExpireDateToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :expire_date, :date
  end
end
