# Inspired by https://github.com/mumoshu/dcind
FROM golang:1
MAINTAINER idahobean <idahobean14@gmail.com>

ENV DOCKER_VERSION=17.05.0-ce \
    DOCKER_COMPOSE_VERSION=1.13.0

# Install Docker and Docker Compose
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get update && apt-get install -y --no-install-recommends \
    iptables libdevmapper-dev python-pip nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    curl https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz | tar zx && \
    mv docker/* /bin/ && chmod +x /bin/docker* && \
    pip install docker-compose==${DOCKER_COMPOSE_VERSION} && \
    npm install npm@latest npm-cli-login -g

ENV CGO_ENABLED 0

# Install entrykit
RUN curl -L https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_Linux_x86_64.tgz | tar zx && \
    chmod +x entrykit && \
    mv entrykit /bin/entrykit && \
    entrykit --symlink

# Include useful functions to start/stop docker daemon in garden-runc containers in Concourse CI.
# Example: source /docker-lib.sh && start_docker
COPY docker-lib.sh /docker-lib.sh

ENTRYPOINT [ \
	"switch", \
		"shell=/bin/sh", "--", \
	"codep", \
		"/bin/dockerd" \
]
