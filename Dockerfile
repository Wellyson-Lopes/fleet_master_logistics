# syntax=docker/dockerfile:1
# check=error=true
ARG RUBY_VERSION=3.4.9
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Install dependencies
RUN apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        zsh \
        libpq-dev \
        htop \
        libyaml-dev \
        tzdata && \
    rm -rf /var/lib/apt/lists/*

# Instalar Oh My Zsh sem pedir interação
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Instalar Powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k && \
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Node.js + yarn
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install --global yarn \
    && yarn set version 1.22.1

# Timezone
ENV TZ=America/Recife
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Rails app lives here
WORKDIR /app

# Copy only Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 4 && gem install foreman -v 0.90.0

# Copy the rest of the application code
COPY . .

SHELL ["/bin/zsh", "-c"]

# Start server
CMD ["./bin/dev"]
