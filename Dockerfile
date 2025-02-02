FROM golang:1.17-alpine as build

RUN apk upgrade --no-cache --force
RUN apk add --update build-base make git

WORKDIR /go/src/github.com/webdevops/azure-resourcegraph-exporter

# Compile
COPY ./ /go/src/github.com/webdevops/azure-resourcegraph-exporter
RUN go mod download
RUN make test
RUN make build
RUN ./azure-resourcegraph-exporter --help

#############################################
# FINAL IMAGE
#############################################
FROM gcr.io/distroless/static
ENV LOG_JSON=1
COPY --from=build /go/src/github.com/webdevops/azure-resourcegraph-exporter/azure-resourcegraph-exporter /
USER 1000:1000
EXPOSE 8080
ENTRYPOINT ["/azure-resourcegraph-exporter"]
