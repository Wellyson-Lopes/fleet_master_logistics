#!/bin/sh
set -e
exec bundle exec sidekiq -c 1
