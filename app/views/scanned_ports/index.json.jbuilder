json.array!(@scanned_ports) do |scanned_port|
  json.extract! scanned_port, :id, :job_time, :organization_id, :host_ip, :number, :protocol, :state, :service
  json.url scanned_port_url(scanned_port, format: :json)
end
