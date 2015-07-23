json.array!(@customers) do |customer|
  json.extract! customer, :id, :we_chat_nickname, :we_chat_openid, :tel_no
  json.url customer_url(customer, format: :json)
end
