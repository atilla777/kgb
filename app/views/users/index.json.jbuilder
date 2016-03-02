json.array!(@users) do |user|
  json.extract! user, :id, :name, :phone, :job, :description, :organization_id, :department
  json.url user_url(user, format: :json)
end
