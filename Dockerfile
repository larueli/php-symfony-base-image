ARG PHP_BUILD_VERSION=8.0

FROM larueli/php-base-image:${PHP_BUILD_VERSION}

ENV PHP_BUILD_VERSION=${PHP_BUILD_VERSION}

ONBUILD USER 0
ONBUILD ARG APP_ENV=dev
ONBUILD ARG COMPOSER_INSTALL_PARAMS=""
ONBUILD ARG COMPOSER_AUTOLOAD_PARAMS=""
ONBUILD ENV APP_ENV=${APP_ENV}
ONBUILD COPY . /var/www/html
ONBUILD RUN echo "/usr/local/bin/php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration" > /docker-entrypoint-init.d/migrations.sh && \
            composer install --no-interaction --no-ansi ${COMPOSER_INSTALL_PARAMS} && \
            composer dump-autoload --classmap-authoritative ${COMPOSER_AUTOLOAD_PARAMS} && \
            chmod g=rwx -R /var/www/html
ONBUILD USER 1547647:0
ONBUILD ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
