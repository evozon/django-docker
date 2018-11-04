from django.apps import AppConfig


class {{ cookiecutter.django_app_name|replace('_', ' ')|title|replace(' ', '') }}Config(AppConfig):
    name = '{{ cookiecutter.django_app_name }}'
