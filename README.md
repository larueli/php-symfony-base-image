[![Build Status](https://travis-ci.com/larueli/php-symfony-base-image.svg?branch=main)](https://travis-ci.com/larueli/php-symfony-base-image)

# PHP Symfony Base Image

Useful to quickly build symfony image suitable for openshift (no root).

This image is using ONBUILD and based on [larueli/php-base-image](https://github.com/larueli/php-base-image), so you just need this in your Dockerfile :

```Dockerfile
FROM larueli/symfony-base-image:8.0
```

It will automagically :

* copy all your files to /var/www/html (make sure to have a .dockerignore !)
* install composer deps : you can add parameters with build arg : COMPOSER_INSTALL_PARAMS
* composer dump-autoload : you can add parameters with build arg : COMPOSER_AUTOLOAD_PARAMS
* install doctrine migrations everytime your docker image starts

It will add all functionnalities from [larueli/php-base-image](https://github.com/larueli/php-base-image) :

* Based on php:apache
* Runs as non-root user.
  * Capable to run with a random user in the root group (compatible with OpenShift)
  * Port 8080 inside the container
* Composer installed
* Using [wait](https://github.com/ufoscout/docker-compose-wait) on top of entrypoint 
* PHP extensions from the base image and I added some

## Production

### Customize

If you want to use this image in production, use it like that if you want to customize it :

```Dockerfile
FROM larueli/symfony-base-image:8.0

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
VOLUME /var/www/html/uploads

USER 0
RUN apt-get update && apt-get install -y optipng && apt-get -y autoremove
USER 2154451:0
```

Never forget to give all permissions to group root because this image should run with any uid inside the root group (OpenShift requirements).

### Build

If you want to build with composer --no-dev in prod, use it like that :

`docker build -t my_incredible_image --build-arg APP_ENV=prod  --build-arg COMPOSER_AUTOLOAD_PARAMS="--no-dev" --build-arg COMPOSER_INSTALL_PARAMS="--no-dev" .`
