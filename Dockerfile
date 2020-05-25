FROM golang:1.13 as build
WORKDIR /src

COPY . .
RUN go mod download && \
    CGO_ENABLED=0 GOOS=linux go build -ldflags "-s -w -X main.version=v1.1.0" -o kucero cmd/kucero/*.go

FROM opensuse/leap:15.2
RUN zypper --non-interactive install kubernetes-client
WORKDIR /bin
COPY --from=build /src/kucero .
ENTRYPOINT ["/bin/kucero"]
