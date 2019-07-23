FROM alpine:3.9

ENV APP_HOME /app

RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/

RUN apk --no-cache add ruby-bundler=1.17.1-r0 ruby-dev=2.5.5-r0 \
    make=4.2.1-r2 gcc=8.3.0-r0 musl-dev=1.1.20-r4 ruby-json=2.5.5-r0 ruby-bigdecimal=2.5.5-r0 \
    && bundle install --clean --no-cache --force \
    && rm -rf /root/.bundle \
    && apk --no-cache del ruby-dev make gcc musl-dev
COPY . $APP_HOME

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

CMD ["puma"]
