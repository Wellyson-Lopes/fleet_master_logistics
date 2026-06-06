#!/bin/sh
set -e

# Wait for PostgreSQL database to be ready
echo "--> Waiting for database to be ready (worker)..."
ruby -r socket -r uri -e '
begin
  $stdout.sync = true
  host = (ENV["DATABASE_URL"] ? URI.parse(ENV["DATABASE_URL"]).host : nil) || "db"
  port = (ENV["DATABASE_URL"] ? URI.parse(ENV["DATABASE_URL"]).port : nil) || 5432
  puts "--> Checking connection to #{host}:#{port}..."
  loop do
    begin
      TCPSocket.new(host, port).close
      break
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError, URI::InvalidURIError => e
      puts "--> Connection failed: #{e.message}. Retrying..."
      sleep 0.5
    end
  end
rescue => e
  puts "Error checking database connection: #{e.message}"
end
'
echo "--> Database is ready!"

bundle check || bundle install --jobs 5 --retry 5

exec bundle exec sidekiq -c 1
