class Customer < ActiveRecord::Base
  has_one :customer_point

  def self.find_or_create(openid)
    customer = Customer.find_by(we_chat_openid: openid)
    if customer.nil?
      customer = Customer.create(we_chat_openid: openid) if customer.nil?
    elsif customer.deleted?
      customer.delete_flag = false
      customer.save
    end
    customer
  end

  def point
    customer_point.nil? ? 0 : customer_point.point
  end

  def update_we_chat_info(we_chat_info)
    self.we_chat_nickname = we_chat_info["nickname"]
    save
  end

  def deleted?
    delete_flag
  end

  def delete_logically
    self.delete_flag = true
    save
  end
end
