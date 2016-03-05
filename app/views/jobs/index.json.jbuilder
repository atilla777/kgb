json.array!(@jobs) do |job|
  json.extract! job, :id, :name, :description, :ports, :hosts, :options
  json.url job_url(job, format: :json)
end
