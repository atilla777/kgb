json.array!(@user_protocols) do |user_protocol|
  json.extract! user_protocol, :id, :user_id, :ip_adress, :action, :controller, :description
  json.url user_protocol_url(user_protocol, format: :json)
end
