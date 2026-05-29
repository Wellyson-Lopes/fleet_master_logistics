# frozen_string_literal: true

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

# Auto-detect if running outside Docker (on host machine) and resolve service hosts dynamically [SC-15]
unless File.exist?("/.dockerenv") || ENV["DOCKERIZED"] == "true"
  require "uri"

  # 1. Resolve PostgreSQL Database host
  if ENV["DATABASE_URL"]
    begin
      uri = URI.parse(ENV["DATABASE_URL"])
      if uri.host == "db"
        uri.host = "localhost"
        ENV["DATABASE_URL"] = uri.to_s
      end
    rescue URI::InvalidURIError
    end
  end

  if ENV["POSTGRES_HOST"] == "db"
    ENV["POSTGRES_HOST"] = "localhost"
  end

  # 2. Resolve Redis host
  if ENV["REDIS_URL"]
    begin
      uri = URI.parse(ENV["REDIS_URL"])
      if uri.host == "redis"
        uri.host = "localhost"
        ENV["REDIS_URL"] = uri.to_s
      end
    rescue URI::InvalidURIError
    end
  end
end
