class PointExchange < ActiveRecord::Base
  belongs_to :customer
  belongs_to :coupon

  validate :exchange_point_should_less_equal_remain_point
  validate :exchange_point_should_greater_equal_coupon_point

  def exchange_point_should_less_equal_remain_point
    if point > customer.customer_point.point
      errors.add(:point, 'remain point not enough!')
    end
  end

  def exchange_point_should_greater_equal_coupon_point
    if point < coupon.value
      errors.add(:point, 'exchange point not enough!')
    end
  end
end
