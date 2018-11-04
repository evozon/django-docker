FROM ubuntu:{{ cookiecutter.ubuntu_version }}

# Note: this uses ubuntu as the base instead of a more lightweight image
# like alpine because fswatch ain't in alpine and we want to use it instead
# of inotifywait which only supports Linux
# (iow: to support Docker for Windows and other setups with strange storage)

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
                    fswatch docker.io dumb-init \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY start.sh /

ENTRYPOINT ["dumb-init"]
CMD ["/start.sh"]
