FROM ruby:2.4.6

# Installing NodeJS for some Ruby gems needed by Rails
RUN apt-get update && apt-get install -y nodejs nginx apache2

ENV APP /app

RUN mkdir $APP
WORKDIR $APP

ENV BUNDLE_GEMFILE=$APP/Gemfile \
    BUNDLE_JOBS=2 \
    BUNDLE_PATH=/bundle

# Copies Gemfile and Gemfile.lock
COPY Gemfile* $APP/

RUN gem install bundler unicorn rack && bundle install

COPY . $APP
COPY apache2ports.conf /etc/apache2/ports.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.default /etc/nginx/sites-available/default
COPY my_first_process my_first_process
COPY my_second_process my_second_process
COPY my_third_process my_third_process
COPY my_wrapper_script.sh my_wrapper_script.sh

# Precompiling assets
RUN bundle exec rake assets:precompile

CMD ./my_wrapper_script.sh

