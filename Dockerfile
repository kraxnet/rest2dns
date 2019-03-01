FROM ruby:2.6.1-alpine
MAINTAINER info@kraxnet.cz

RUN apk add knot git build-base

WORKDIR /usr/app

COPY Gemfile.docker /usr/app/Gemfile
RUN bundle config github.https true
RUN bundle config --global silence_root_warning 1
RUN bundle install
