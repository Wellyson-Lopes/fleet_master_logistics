#!/bin/sh
set -e

bundle check || bundle install --jobs 5 --retry 5

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
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
