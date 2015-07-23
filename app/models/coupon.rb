class Coupon < ActiveRecord::Base
  def used_status
    used? ? '已' : '未'
  end

  def display_name
    [vender, password, value.to_s + '元'].join(' ')
  end
end
