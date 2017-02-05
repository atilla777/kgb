path_to_key="./server.key"
path_to_cert="./server.crt"

preload_app!

rackup      DefaultRackup
environment ENV['RAILS_ENV'] || 'development'
bind "tcp://127.0.0.1:#{ENV['PORT']}"
ssl_bind '0.0.0.0', ENV['SSL_PORT'], { key: path_to_key, cert: path_to_cert }
