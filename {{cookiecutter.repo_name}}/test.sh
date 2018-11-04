#!/bin/bash -eux
if [[ "$@" = "--help" || "$@" = "-h" ]]; then
    set +x
    echo "
Usage: ./test.sh command-to-run arguments

Examples:

- run the default (pytest):

    ./test.sh

- run pytest with arguments:

    ./test.sh pytest -k mytest

- make migrations:

    ./test.sh django-admin makemigrations

- do interactive stuff:

    ./test.sh bash

- disable building:

    NOBUILD=1 ./test.sh

- disable service teardown (faster but less safe runs):

    NOCLEAN=1 ./test.sh
"
    exit 0
fi

DOCKER_CMD="docker-compose -f docker-compose.yml -f docker-compose.test.yml -p {{ cookiecutter.compose_project_name }}test"

USER="${USER:-$(id -nu)}"
if [[ "$(uname)" == "Darwin" ]]; then
    USER_UID=1000
    USER_GID=1000
else
    USER_UID="$(id --user "$USER")"
    USER_GID="$(id --group "$USER")"
fi

if [[ -z "${NOBUILD:-}" ]]; then
    $DOCKER_CMD build \
                --build-arg "PROJECT_NAME={{ cookiecutter.compose_project_name }}test" \
                base
    $DOCKER_CMD build \
                --build-arg "LOCAL_USER=$USER" \
                --build-arg "LOCAL_UID=$USER_UID" \
                --build-arg "LOCAL_GID=$USER_GID" \
                test
fi
if [[ -z "$@" ]]; then
    set -- pytest
fi

homedir=$(dirname ${BASH_SOURCE[0]})/.home
if [[ ! -e $homedir ]]; then
    # create it here so Docker don't create with root ownership
    mkdir $homedir
fi

function cleanup {
    echo "Cleaning up ..."
    $DOCKER_CMD down && $DOCKER_CMD rm -fv
}
if [[ -z "${NOCLEAN:-}" ]]; then
    trap cleanup EXIT
    cleanup || echo "Already clean :-)"
fi

$DOCKER_CMD run --rm --user=$USER test "$@"
