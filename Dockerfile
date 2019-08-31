FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash
RUN apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install yarn
RUN apt-get install -y vim
ENV EDITOR vim
RUN mkdir /reactapp
WORKDIR /reactapp
ADD Gemfile /reactapp/Gemfile
ADD Gemfile.lock /reactapp/Gemfile.lock
RUN bundle install
ADD . /reactapp
