# Base django docker image

[![](https://images.microbadger.com/badges/image/gdml/django-base.svg)](https://microbadger.com/images/f213/periodic-docker-prune "Get your own image badge on microbadger.com")
![](https://img.shields.io/docker/build/gdml/django-base.svg) ![](https://img.shields.io/docker/pulls/gdml/django-base.svg)

## Usage

```docker
FROM gdml/django-base

WORKDIR /srv

ADD . /srv
RUN ./manage.py compilemessages
RUN ./manage.py collectstatic --noinput

# Developer machine, autoreload
CMD ["dockerize", "-wait", "tcp://postgres:5432", "-timeout", "60s",   "./manage.py", "runserver", "0.0.0.0:8000"]

# Prod machine
CMD ["uwsgi", "--http", ":8000", "--module", "app.wsgi", "--workers", "2", "--threads", "2"]
```

Your `requirements.txt` should be located in the same folder as the Dockerfile.

## Contents
* Python 3.7 (based on official slim images)
* UWSGI
* [dockerize](https://github.com/jwilder/dockerize)
* [wkhtmltopdf](https://wkhtmltopdf.org)


