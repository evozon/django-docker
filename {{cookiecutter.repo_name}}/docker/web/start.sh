#!/bin/bash -eux
django-admin migrate --noinput
if [[ -n "${COLLECTSTATIC:-}" ]]; then
    django-admin collectstatic --noinput -v1
fi
exec uwsgi --ini /etc/uwsgi.ini "$@"
