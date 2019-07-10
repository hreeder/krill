FROM ubuntu:rolling
LABEL maintainer="Harry Reeder <harry@reeder.dev>"

CMD ["/usr/bin/tail", "-f", "/dev/null"]