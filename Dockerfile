FROM ruby:3.1.3

WORKDIR /application

COPY /application /application

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN gem install bundler
RUN bundle install --jobs 4

EXPOSE 4000

CMD ["sh", "server.sh"]
