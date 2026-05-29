# syntax=docker/dockerfile:1
# check=error=true
ARG RUBY_VERSION=3.4.9
FROM ruby:$RUBY_VERSION-slim

# Install dependencies
RUN apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
      build-essential \
      curl \
      libpq-dev \
      htop \
      libyaml-dev \
      tzdata && \
    rm -rf /var/lib/apt/lists/*

# Timezone
ENV TZ=America/Recife
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Rails app lives here
WORKDIR /app

# Copy only Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 5 --retry 5

# Copy the rest of the application code
COPY . .

# Copy entrypoint script
COPY ./worker/entrypoint.sh /app/worker/entrypoint.sh
RUN chmod +x /app/worker/entrypoint.sh

# Start worker
CMD ["bash", "/app/worker/entrypoint.sh"]
