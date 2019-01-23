FROM buildpack-deps:{{ cookiecutter.ubuntu_version }} AS deps

ARG PROJECT_NAME
ARG DJANGO_SECRET_KEY
RUN if [ -z "$PROJECT_NAME" -o -z "$DJANGO_SECRET_KEY" ]; then \
    echo '\033[1;31m\n\tRefusing to build project.\n\
          \n\tPlease run `cp .env-PLATFORM .env` or similar first! \
          \n\tMake sure the `.env` file has the COMPOSE_PROJECT_NAME setting.\n'; exit 1; fi

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
                    python3-dev libgraphviz-dev \
                    wget ca-certificates \
 && echo 'deb http://apt.postgresql.org/pub/repos/apt/ {{ cookiecutter.ubuntu_version }}-pgdg main {{ cookiecutter.postgresql_version }}' > /etc/apt/sources.list.d/pgdg.list \
 && curl -fsSL11 'https://www.postgresql.org/media/keys/ACCC4CF8.asc' | apt-key add - \
 && apt-get update \
 && apt-get install -y --no-install-recommends --allow-downgrades \
                    'libpq-dev={{ cookiecutter.postgresql_version }}.*' 'libpq5={{ cookiecutter.postgresql_version }}.*' \
 && rm -rf /var/lib/apt/lists/*

RUN bash -o pipefail -c "curl -fsSL 'https://bootstrap.pypa.io/get-pip.py' | \
    python3 - --disable-pip-version-check --no-cache-dir --upgrade pip=={{ cookiecutter.pip_version }}"

COPY requirements.txt /
RUN mkdir /wheels \
 && pip wheel --no-cache --wheel-dir=/wheels -rrequirements.txt


########################################################################################################################
FROM ubuntu:{{ cookiecutter.ubuntu_version }}
########################################################################################################################

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
                    locales software-properties-common \
                    curl wget ca-certificates gpg-agent \
                    strace gdb lsof locate net-tools htop iputils-ping dnsutils \
                    python3-distutils \
                    python3-dbg libpython3-dbg \
                    nano vim tree less telnet socat \
                    graphviz \
 && echo 'deb http://apt.postgresql.org/pub/repos/apt/ {{ cookiecutter.ubuntu_version }}-pgdg main {{ cookiecutter.postgresql_version }}' > /etc/apt/sources.list.d/pgdg.list \
 && curl -fsSL 'https://www.postgresql.org/media/keys/ACCC4CF8.asc' | apt-key add - \
 && apt-get update \
 && apt-get install -y --no-install-recommends --allow-downgrades \
                    'libpq5={{ cookiecutter.postgresql_version }}.*' \
                    postgresql-client-{{ cookiecutter.postgresql_version }} \
 && rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN locale-gen en_US.UTF-8

ENV TERM=xterm

RUN bash -o pipefail -c "curl -fsSL 'https://bootstrap.pypa.io/get-pip.py' | \
    python3 - --disable-pip-version-check --no-cache-dir --upgrade pip=={{ cookiecutter.pip_version }}"

RUN mkdir /deps
COPY --from=deps /wheels/* /deps/
RUN pip install --force-reinstall --ignore-installed --upgrade --no-index --no-deps /deps/* \
 && mkdir /app /var/app

# Create django user, will own the Django app
RUN adduser --no-create-home --disabled-login --group --system app
RUN chown -R app:app /app /var/app

RUN echo /app/src > $(python3 -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())')/app.pth

ENV DJANGO_SETTINGS_MODULE="{{ cookiecutter.django_project_name }}.settings"
ENV PYTHONUNBUFFERED=x
ARG DJANGO_SECRET_KEY
ENV DJANGO_SECRET_KEY=$DJANGO_SECRET_KEY
