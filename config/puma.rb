path_to_key="./server.key"
path_to_cert="./server.crt"

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RAILS_ENV'] || 'development'
ssl_bind '0.0.0.0', ENV['SSL_PORT'], { key: path_to_key, cert: path_to_cert }
