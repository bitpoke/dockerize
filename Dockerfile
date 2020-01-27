FROM golang:1.13.6-alpine3.11 AS binary
ENV GO111MODULE=on
RUN apk -U add openssl git

ADD . /go/src/github.com/jwilder/dockerize
WORKDIR /go/src/github.com/jwilder/dockerize

RUN go install

FROM alpine:3.11
MAINTAINER Jason Wilder <mail@jasonwilder.com>

COPY --from=binary /go/bin/dockerize /usr/local/bin

ENTRYPOINT ["dockerize"]
CMD ["--help"]
