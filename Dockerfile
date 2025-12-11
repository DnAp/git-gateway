FROM golang:1.22.3 AS builder

WORKDIR /go/src/github.com/netlify/git-gateway

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -ldflags "-X github.com/netlify/git-gateway/cmd.Version=$(git rev-parse HEAD)" -o git-gateway

FROM golang:1.22.3
RUN useradd -m netlify
COPY --from=builder /go/src/github.com/netlify/git-gateway/git-gateway /usr/local/bin/

USER netlify
CMD ["git-gateway"]
