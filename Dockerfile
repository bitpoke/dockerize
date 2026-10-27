# renovate: datasource=golang-version depName=go
ARG GO_VERSION=1.13
ARG ALPINE_VERSION=3.11

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS binary
ENV GO111MODULE=on
RUN apk -U add openssl git

ADD . /go/src/github.com/jwilder/dockerize
WORKDIR /go/src/github.com/jwilder/dockerize

RUN go install

FROM alpine:${ALPINE_VERSION}
MAINTAINER Jason Wilder <mail@jasonwilder.com>

COPY --from=binary /go/bin/dockerize /usr/local/bin

ENTRYPOINT ["dockerize"]
CMD ["--help"]
