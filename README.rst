====================
evozon/docker-django
====================

A Cookiecutter_ template for a Django_ project using Docker_. A description of the rationale behind this template is in
`this blog post <https://www.evozon.com/blog/a-project-template-for-getting-started-with-django-and-docker>`_.

What is included?

* Packages for Django_ project and an app
* Setup for Celery_, uWSGI_, debug-toolbar etc
* Setup for testing using Pytest_.
* Reloader (container that restarts other containers when files change, for development).

Generating the project
----------------------

`Install cookiecutter <https://cookiecutter.readthedocs.io/en/latest/installation.html#install-cookiecutter>`_ and run::

    cookiecutter gh:evozon/docker-django

You will be asked for these fields:

.. list-table::
    :header-rows: 1

    * - Template variable
      - Default
      - Description

    * - ``name``
      - .. code:: python

            "Nameless"
      - Project name, used in headings (readme, etc).

    * - ``repo_name``
      - .. code:: python

            "python-nameless"
      - The project's root directory name.

    * - ``django_project_name``
      - .. code:: python

            "nameless_project"
      - Django project name (a package that contains settings and root urls).

    * - ``compose_project_name``
      - .. code:: python

            "nmls"
      - Docker Compose project name (used for the COMPOSE_PROJECT_NAME setting). A short name is suggested to avoid
        typing a lot when using Docker directly (eg: ``docker exec nmls_web_1 ...``)

    * - ``django_app_name``
      - .. code:: python

            "nameless"
      - Django app name.

    * - ``short_description``
      - .. code:: python

            "An example package [...]"
      - One line description of the project (used in ``README.rst``).

Regenerating the project
------------------------

If you made some wrong choices during generation you can regenerate it. There are two options:

* Force Cookiecutter_ to override the files::

    cookiecutter --overwrite-if-exists --config-file=directory-of-project/.cookiecutterrc gh:evozon/docker-django

* After installing `cookiepatcher <https://pypi.org/project/cookiepatcher/>`_ run::

    cookiepatcher gh:evozon/docker-django directory-of-project

Using the project
-----------------

There will be a base image, so for an accurate image building process do this::

    docker-compose build --pull base
    docker-compose build

To start the project run::

    docker-compose up

The project will provide a small shim for running tests, try::

  ./test.sh --help

Working with the project is the usual ``docker-compose up`` and such, nothing special or unexpected.

.. _Pytest: http://pytest.org/
.. _Cookiecutter: https://github.com/audreyr/cookiecutter
.. _Docker: https://www.docker.com/
.. _Django: https://www.djangoproject.com/
.. _Celery: http://www.celeryproject.org/
.. _uWSGI: https://uwsgi-docs.readthedocs.io/
