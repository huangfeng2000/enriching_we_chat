class AddCommentToCostomerPoints < ActiveRecord::Migration
  def change
    add_column :customer_points, :comment, :text
  end
end
