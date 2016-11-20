FROM            golang:1.7
MAINTAINER      Guillaume J. Charmes <guillaume@charmes.net>

# Install linters
RUN             go get github.com/alecthomas/gometalinter && gometalinter -i

# Disable CGO and recompile the stdlib.
ENV             CGO_ENABLED 0
RUN             go install -a -ldflags '-d -w' std

ARG             APP_DIR=github.com/creack/yaml2json

WORKDIR         $GOPATH/src/$APP_DIR

ADD             .          $GOPATH/src/$APP_DIR

RUN             go install -ldflags '-d -w'
