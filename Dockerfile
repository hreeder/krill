FROM ubuntu:rolling
LABEL maintainer="Harry Reeder <harry@reeder.dev>"

RUN apt-get update && apt-get install -y \
    bind9-host \
    curl \
    dnsutils \
    httpie \
    iputils-ping \
    postgresql-client \
 && rm -rf /var/lib/apt/lists/*

CMD ["/usr/bin/tail", "-f", "/dev/null"]