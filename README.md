# Base django docker image

## Usage

```docker
FROM gdml/django-base

ADD . /srv/
WORKDIR /SRV

# Developer machine, autoreload
CMD ["dockerize", "-wait", "tcp://postgres:5432", "-timeout", "60s",   "./manage.py", "runserver", "0.0.0.0:8000"]

# Prod machine
CMD ["uwsgi", "--http", ":8000", "--module", "app.wsgi", "--workers", "2", "--threads", "2"]
```

Your `requirements.txt` should be located in the same folder as the Dockerfile.

## Contents
* Python 3.6 (based on official slim images)
* UWSGI
* [dockerize](https://github.com/jwilder/dockerize)
* [wkhtmltopdf](https://wkhtmltopdf.org)


