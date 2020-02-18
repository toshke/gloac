FROM ruby:2.5-alpine

ARG GEM_VERSION=0.0.1

WORKDIR /src
COPY gloac-${GEM_VERSION}.gem .
RUN gem install gloac-${GEM_VERSION}.gem

RUN adduser -u 1000 -D gloac && \
    apk add --update git openssh-client bash

WORKDIR /work

USER gloac

# required for any calls via aws sdk
ENV AWS_REGION us-east-1
ENV AWS_DEFAULT_REGION us-east-1

CMD 'gloac'
