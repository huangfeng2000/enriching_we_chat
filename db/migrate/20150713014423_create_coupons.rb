class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :vender
      t.string :password
      t.integer :value

      t.timestamps
    end
  end
end
