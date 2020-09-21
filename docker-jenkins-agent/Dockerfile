FROM teamserverless/license-check:0.3.6 as license-check

# Build stage
FROM golang:1.13 as builder

ENV GO111MODULE=on
ENV GOFLAGS=-mod=vendor
ENV CGO_ENABLED=0

WORKDIR /usr/bin/

COPY --from=license-check /license-check /usr/bin/

WORKDIR /go/src/github.com/openfaas/faas-cli
COPY docker-jenkins-agent/faas-cli/ .

# Run a gofmt and exclude all vendored code.
RUN test -z "$(gofmt -l $(find . -type f -name '*.go' -not -path "./vendor/*"))" || { echo "Run \"gofmt -s -w\" on your Golang code"; exit 1; }

# ldflags "-s -w" strips binary
# ldflags -X injects commit version into binary
RUN /usr/bin/license-check -path ./ --verbose=false "Alex Ellis" "OpenFaaS Author(s)"

RUN go test $(go list ./... | grep -v /vendor/ | grep -v /template/|grep -v /build/|grep -v /sample/) -cover

RUN VERSION=$(git describe --all --exact-match `git rev-parse HEAD` | grep tags | sed 's/tags\///') \
    && GIT_COMMIT=$(git rev-list -1 HEAD) \
    && CGO_ENABLED=0 GOOS=linux go build --ldflags "-s -w \
    -X github.com/openfaas/faas-cli/version.GitCommit=${GIT_COMMIT} \
    -X github.com/openfaas/faas-cli/version.Version=${VERSION} \
    -X github.com/openfaas/faas-cli/commands.Platform=x86_64" \
    -a -installsuffix cgo -o faas-cli

# CICD stage
FROM alpine:3.12 as root

RUN apk --no-cache add ca-certificates git

WORKDIR /home/app

COPY --from=builder /go/src/github.com/openfaas/faas-cli/faas-cli               /usr/bin/

ENV PATH=$PATH:/usr/bin/

ENTRYPOINT [ "faas-cli" ]

# JENKINS AGENT
FROM stifstof/jnlp-slave-arm:latest

USER root

# INSTALL DOCKER COMPOSE
RUN apt-get update
RUN apt-get install -y libffi-dev libssl-dev
RUN apt-get install -y python3 python3-pip
RUN apt-get remove python-configparser
RUN pip3 -v install docker-compose
RUN export PATH="$PATH:/usr/bin/docker-compose:/usr/local/bin/docker-compose"
RUN docker-compose --version

# UPGRADE PYTHON
RUN apt-get upgrade -y
RUN apt-get autoremove -y
RUN apt-get dist-upgrade
RUN python3 --version

# INSTALL DOCKER
RUN apt install -y apt-transport-https ca-certificates curl software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=armhf] https://download.docker.com/linux/ubuntu bionic stable"
RUN apt-get update
RUN apt-cache policy docker-ce
RUN apt install docker-ce -y
RUN service docker start
RUN export PATH="$PATH:/usr/bin/docker"
RUN docker --version

# Install faas-cli from root image
COPY --from=root /usr/bin/faas-cli /usr/bin/faas-cli
RUN ln -sf /usr/bin/faas-cli /usr/local/bin/faas
ENV PATH=$PATH:/usr/bin/
RUN faas-cli

