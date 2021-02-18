FROM golang:1.14.3-alpine as build

WORKDIR /build

COPY . ./

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags '-extldflags "-static"' -o pkg/linux_amd64/http-echo

FROM scratch
LABEL maintainer "Seth Vargo <seth@sethvargo.com> (@sethvargo)"

ADD "https://curl.haxx.se/ca/cacert.pem" "/etc/ssl/certs/ca-certificates.crt"

COPY --from=build "/build/pkg/linux_amd64/http-echo" "/"

ENTRYPOINT ["/http-echo"]
