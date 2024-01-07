# Use ruby image to build our own image
FROM ruby:3.3.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y postgresql-client libvips cron \
                       && curl -sSL https://deb.nodesource.com/setup_18.x | bash - \
                       && curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
                       && echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list \
                       && apt-get update && apt-get install -y --no-install-recommends nodejs yarn

# Create work dir
RUN mkdir /app
WORKDIR /app

# Set build-time variables
ARG RAILS_ENV=production
ARG BUILDING_DOCKER_IMAGE=true

# This value is only set such that the asset precompile works. It
# will not be available to the final container and you need to
# set the value in your docker compose
ARG SECRET_KEY_BASE=583364b0aaaef81adc0d476c18efec0c

# Install gems, skipping the test and development gems
## Copy gemfiles
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
## Copy payment gateways
COPY payment_gateways/ /app/payment_gateways/
## Run bundle
RUN bundle config set --local without 'test development'
RUN bundle install

# Install yarn packages
COPY package.json /app/package.json
COPY yarn.lock /app/yarn.lock
RUN yarn install

# Add env var to enable YJIT
ENV RUBY_YJIT_ENABLE true

# Copy rails code
ADD . /app

# Precompile assets
RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]