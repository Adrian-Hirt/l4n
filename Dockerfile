# Use ruby image to build our own image
FROM ruby:3.1.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y postgresql-client libvips \
                       && curl -sSL https://deb.nodesource.com/setup_18.x | bash - \
                       && curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
                       && echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list \
                       && apt-get update && apt-get install -y --no-install-recommends nodejs yarn

# Create work dir
RUN mkdir /app
WORKDIR /app

# Install gems
ADD . /app
RUN bundle install

# Install yarn packages
RUN yarn install

# Precompile assets
RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]