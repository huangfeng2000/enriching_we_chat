json.array!(@coupons) do |coupon|
  json.extract! coupon, :id, :vender, :password, :value
  json.url coupon_url(coupon, format: :json)
end
