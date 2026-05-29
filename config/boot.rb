# frozen_string_literal: true

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

# Auto-detect if running outside Docker (on host machine) and resolve service hosts dynamically [SC-15]
unless File.exist?("/.dockerenv") || ENV["DOCKERIZED"] == "true"
  # 1. Resolve PostgreSQL Database host
  if ENV["DATABASE_URL"]
    ENV["DATABASE_URL"] = ENV["DATABASE_URL"]
      .gsub("@db:", "@localhost:")
      .gsub("@db/", "@localhost/")
  end

  if ENV["POSTGRES_HOST"] == "db"
    ENV["POSTGRES_HOST"] = "localhost"
  end

  # 2. Resolve Redis host
  if ENV["REDIS_URL"]
    ENV["REDIS_URL"] = ENV["REDIS_URL"]
      .gsub("//redis:", "//localhost:")
      .gsub("//redis/", "//localhost/")
  end
end
