module ApplicationHelper
  def customer_codes
    Customer.all.map do | customer |
      [customer.we_chat_nickname, customer.id]
    end
  end

  def use_status_codes
    [['未', 0], ['已', 1]]
  end

  def coupon_codes
    Coupon.all.map do | coupon |
      [coupon.display_name, coupon.id]
    end
  end
end
