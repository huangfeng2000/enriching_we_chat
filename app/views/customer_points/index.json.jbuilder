json.array!(@customer_points) do |customer_point|
  json.extract! customer_point, :id, :customer_id, :point, :comment
  json.url customer_point_url(customer_point, format: :json)
end
