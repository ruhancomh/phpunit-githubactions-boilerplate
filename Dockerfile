FROM php:7.3.4-fpm

LABEL maintainer="Ruhan de Oliveira Baiense"

RUN apt-get update -y && apt-get install -y zip libzip-dev unzip git libmcrypt-dev mysql-client \
    && pecl install mcrypt-1.0.2 \
    && docker-php-ext-enable mcrypt \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY ./application/composer.json /var/www/html/composer.json
COPY ./application/composer.lock /var/www/html/composer.lock

WORKDIR /var/www/html

RUN composer install --no-scripts --no-autoloader

ENTRYPOINT [ "php", "-S", "0.0.0.0:8000", "-t", "public"]