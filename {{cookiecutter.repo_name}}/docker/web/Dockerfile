FROM {{ cookiecutter.compose_project_name }}_base

COPY docker/web/uwsgi.ini /etc/
COPY docker/web/start.sh /

COPY src /app/src
WORKDIR /app

RUN pysu app django-admin collectstatic --noinput -v0
