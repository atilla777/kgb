json.array!(@option_sets) do |option_set|
  json.extract! option_set, :id, :name, :description, :options
  json.url option_set_url(option_set, format: :json)
end
