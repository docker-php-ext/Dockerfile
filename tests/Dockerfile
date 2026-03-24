ARG PHP_VERSION
ARG DISTRO
ARG EXTENSION

FROM $EXTENSION:php$PHP_VERSION-$DISTRO as ext
FROM php:$PHP_VERSION-$DISTRO

ENV PHP_INI_SCAN_DIR=/opt/php/conf.d

COPY --from=ext /opt/php /opt/php

COPY test.php /opt/php/tests/test.php
