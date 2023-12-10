# syntax=docker/dockerfile:1
FROM ruby:3.1.3

RUN apt-get update -qq && apt-get install -y postgresql-client vim
# install postgresql-client-14
RUN apt-get update -y
RUN apt-get install -y lsb-release
RUN sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-client-14


WORKDIR /chess_results
COPY Gemfile /chess_results/Gemfile
COPY Gemfile.lock /chess_results/Gemfile.lock
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]