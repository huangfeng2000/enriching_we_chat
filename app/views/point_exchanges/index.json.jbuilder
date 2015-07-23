json.array!(@point_exchanges) do |point_exchange|
  json.extract! point_exchange, :id, :customer_id, :point, :coupon_id
  json.url point_exchange_url(point_exchange, format: :json)
end
