from __future__ import print_function

import random
from os.path import join


def replace_content(filename, what, replacement):
    with open(filename) as fh:
        content = fh.read()
    with open(filename, 'w') as fh:
        fh.write(content.replace(what, replacement))


if __name__ == "__main__":
    print("""
################################################################################
################################################################################

    You have succesfully created `{{ cookiecutter.repo_name }}`.

################################################################################

    You've used these cookiecutter parameters:
    
{% for key, value in cookiecutter.items()|sort %}{% if key != '_template' %}
        {{ "{0:26}".format(key + ":") }} {{ "{0!r}".format(value).strip("u") }}
{%- endif %}{%- endfor %}

################################################################################

    To get started.  Make a copy of the appropriate platform .env file.

        cd {{ cookiecutter.repo_name }}
        cp .env-linux-osx .env
          or
        cp .env-windows .env

    Then run these

        docker-compose build --pull base
        docker-compose build
        docker-compose up
""")
    secret_key = ''.join(
        random.SystemRandom().choice('abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)')
        for i in range(50)
    )
    replace_content('.env-linux-osx', '<SECRET_KEY>', secret_key)
    replace_content('.env-windows', '<SECRET_KEY>', secret_key)
