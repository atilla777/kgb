json.array!(@services) do |service|
  json.extract! service, :id, :name, :organization_id, :legality, :host_ip, :port, :protocol, :description
  json.url service_url(service, format: :json)
end
