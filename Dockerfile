FROM python:3.6-slim-stretch
LABEL maintainer="fb@gdml.ru"

ENV PYTHONUNBUFFERED 1
ENV DEBIAN_FRONTEND noninteractive
ENV STATIC_ROOT /static
ENV DOCKERIZE_VERSION v0.6.1
ENV WKHTMLTOPDF_VERSION 0.12.3

VOLUME /static
VOLUME /media
EXPOSE 6000

RUN echo deb http://deb.debian.org/debian stretch contrib non-free > /etc/apt/sources.list.d/debian-contrib.list \
    && apt-get update \
    && apt-get --no-install-recommends install -y gettext locales-all wget

RUN apt-get --no-install-recommends install -y build-essential libxml2-dev libxslt1-dev && \
        apt-get --no-install-recommends install -y libjpeg62-turbo-dev libjpeg-dev libfreetype6-dev libtiff5-dev liblcms2-dev libwebp-dev tk8.6-dev && \
        apt-get --no-install-recommends install -y libffi-dev libcgraph6 libgraphviz-dev

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/$WKHTMLTOPDF_VERSION/wkhtmltox-${WKHTMLTOPDF_VERSION}_linux-generic-amd64.tar.xz \
    && tar -xJf wkhtmltox-*.tar.xz \
    && cp -R wkhtmltox/* /usr \
    && rm -Rf wkhtmltox*

RUN pip install uwsgi

ONBUILD ADD requirements.txt /
ONBUILD run pip install -r /requirements.txt
