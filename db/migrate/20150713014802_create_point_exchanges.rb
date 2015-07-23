class CreatePointExchanges < ActiveRecord::Migration
  def change
    create_table :point_exchanges do |t|
      t.integer :customer_id
      t.integer :point
      t.integer :coupon_id

      t.timestamps
    end
  end
end
