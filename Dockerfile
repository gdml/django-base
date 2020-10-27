FROM python:3.8.6-slim-buster
LABEL maintainer="developers@gdml.ru"

LABEL com.datadoghq.ad.logs='[{"source": "uwsgi", "service": "django"}]'

ENV PYTHONUNBUFFERED 1
ENV DEBIAN_FRONTEND noninteractive

ENV STATIC_ROOT /static
ENV MEDIA_ROOT /media

ENV _UWSGI_VERSION 2.0.19.1
ENV DOCKERIZE_VERSION v0.6.1
ENV WKHTMLTOPDF_VERSION 0.12.3

VOLUME /static
VOLUME /media

EXPOSE 8000

RUN echo deb http://deb.debian.org/debian stretch contrib non-free > /etc/apt/sources.list.d/debian-contrib.list \
    && apt-get update \
    && apt-get --no-install-recommends install -y gettext locales-all wget imagemagick tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get --no-install-recommends install -y build-essential libxml2-dev libxslt1-dev \
    && apt-get --no-install-recommends install -y libjpeg62-turbo-dev libjpeg-dev libfreetype6-dev libtiff5-dev liblcms2-dev libwebp-dev tk8.6-dev \
    && apt-get --no-install-recommends install -y libffi-dev libcgraph6 libgraphviz-dev libmagic-dev \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y libssl1.1 \
    && echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections \
    && apt-get install -y --no-install-recommends fontconfig ttf-mscorefonts-installer \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/$WKHTMLTOPDF_VERSION/wkhtmltox-${WKHTMLTOPDF_VERSION}_linux-generic-amd64.tar.xz \
    && tar -xJf wkhtmltox-*.tar.xz \
    && rm -f wkhtmltox/bin/wkhtmltoimage \
    && cp -R wkhtmltox/* /usr \
    && rm -Rf wkhtmltox*

RUN wget -O uwsgi-${_UWSGI_VERSION}.tar.gz https://github.com/unbit/uwsgi/archive/${_UWSGI_VERSION}.tar.gz \
    && tar zxvf uwsgi-*.tar.gz \
    && UWSGI_BIN_NAME=/usr/local/bin/uwsgi make -C uwsgi-${_UWSGI_VERSION} \
    && rm -Rf uwsgi-*

