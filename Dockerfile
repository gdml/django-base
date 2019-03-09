FROM python:3.6-slim-stretch
LABEL maintainer="fedor@borshev.com"

ENV PYTHONUNBUFFERED 1
ENV DEBIAN_FRONTEND noninteractive

ENV STATIC_ROOT /static
ENV MEDIA_ROOT /media

ENV DOCKERIZE_VERSION v0.6.1
ENV WKHTMLTOPDF_VERSION 0.12.3

VOLUME /static
VOLUME /media

EXPOSE 8000

RUN echo deb http://deb.debian.org/debian stretch contrib non-free > /etc/apt/sources.list.d/debian-contrib.list \
    && apt-get update \
    && apt-get --no-install-recommends install -y gettext locales-all wget imagemagick tzdata

RUN apt-get --no-install-recommends install -y build-essential libxml2-dev libxslt1-dev \
    && apt-get --no-install-recommends install -y libjpeg62-turbo-dev libjpeg-dev libfreetype6-dev libtiff5-dev liblcms2-dev libwebp-dev tk8.6-dev \
    && apt-get --no-install-recommends install -y libffi-dev libcgraph6 libgraphviz-dev libmagic-dev

RUN apt-get install -y libssl1.0-dev \
    && echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections \
    && apt-get install -y --no-install-recommends fontconfig ttf-mscorefonts-installer

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/$WKHTMLTOPDF_VERSION/wkhtmltox-${WKHTMLTOPDF_VERSION}_linux-generic-amd64.tar.xz \
    && tar -xJf wkhtmltox-*.tar.xz \
    && cp -R wkhtmltox/* /usr \
    && rm -Rf wkhtmltox*

RUN wget -O uwsgi-2.0.17.1.tar.gz https://github.com/unbit/uwsgi/archive/2.0.17.1.tar.gz \
    && tar zxvf uwsgi-*.tar.gz \
    && UWSGI_BIN_NAME=/usr/local/bin/uwsgi make -C uwsgi-2.0.17.1 \
    && rm -Rf uwsgi-*

ONBUILD ADD requirements.txt /
ONBUILD run pip install -r /requirements.txt
