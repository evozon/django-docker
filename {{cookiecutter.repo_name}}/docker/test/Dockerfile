FROM buildpack-deps:{{ cookiecutter.ubuntu_version }} AS deps

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
                    python3-dev libgraphviz-dev \
 && rm -rf /var/lib/apt/lists/*

RUN bash -o pipefail -c "curl -fSL 'https://bootstrap.pypa.io/get-pip.py' | python3 - --no-cache-dir --upgrade pip=={{ cookiecutter.pip_version }}"

COPY requirements-test.txt /
RUN mkdir /wheels \
 && pip wheel --no-cache --wheel-dir=/wheels -rrequirements-test.txt


########################################################################################################################
FROM {{ cookiecutter.compose_project_name }}test_base
########################################################################################################################

COPY --from=deps /wheels/* /deps/
RUN pip install --force-reinstall --ignore-installed --upgrade --no-index --no-deps /deps/* \
 && rm -rf /deps

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
                    sudo zsh \
 && rm -rf /var/lib/apt/lists/*

ARG LOCAL_USER
ARG LOCAL_UID
ARG LOCAL_GID
ENV LOCAL_USER=$LOCAL_USER

RUN echo "User name: $LOCAL_USER ($LOCAL_UID:$LOCAL_GID)" \
 && mkdir -p /home/app \
 && getent passwd $LOCAL_USER || ( \
      echo "Creating user: $LOCAL_USER ($LOCAL_UID:$LOCAL_GID)" && \
      groupadd --system --gid=$LOCAL_GID $LOCAL_USER && \
      useradd --system --home-dir=/home/app --gid=$LOCAL_GID --uid=$LOCAL_UID $LOCAL_USER \
    ) \
 && chown $LOCAL_USER:$LOCAL_USER /home/app \
 && echo "$LOCAL_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$LOCAL_USER

COPY docker/test/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

COPY pytest.ini /app/
COPY src /app/src
COPY docker/test/.coveragerc /app/

WORKDIR /app
