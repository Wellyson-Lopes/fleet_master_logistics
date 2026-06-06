#!/bin/sh
set -e

# Wait for PostgreSQL database to be ready
echo "--> Waiting for database to be ready..."
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

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

if [ "$RAILS_ENV" = "development" ]; then
  echo '--> Preparing database'
  bundle exec rails db:prepare
  echo '--> Building Tailwind CSS'
  bundle exec rails tailwindcss:build
fi

if [ "$RAILS_ENV" != "development" ]; then
  echo '--> Running migrations'
  rails db:migrate
  echo '--> end migrations'
  echo '--> Precompiling assets'
  rails assets:precompile
  echo '--> Cleaning assets'
  rails assets:clobber
else
  echo '--> Skiping assets precompilation on development'
fi

exec "$@" # executa o command do container
