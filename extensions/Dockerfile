ARG PHP_VERSION
ARG DISTRO
ARG BUILDER_IMAGE

FROM ${BUILDER_IMAGE} AS ext
FROM php:$PHP_VERSION-$DISTRO

ENV PHP_INI_SCAN_DIR=/opt/php/conf.d:/usr/local/etc/php/conf.d

COPY --from=ext /opt/php /opt/php
