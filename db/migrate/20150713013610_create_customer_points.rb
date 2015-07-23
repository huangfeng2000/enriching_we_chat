class CreateCustomerPoints < ActiveRecord::Migration
  def change
    create_table :customer_points do |t|
      t.integer :customer_id
      t.integer :point

      t.timestamps
    end
  end
end
