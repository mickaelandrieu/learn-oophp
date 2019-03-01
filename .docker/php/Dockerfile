FROM php:7.2-apache

COPY . /srv/app
COPY vhost.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /srv/app

RUN docker-php-ext-install mbstring pdo pdo_mysql \
    && chown -R www-data:www-data /srv/app

# Install Composer globally
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    /usr/local/bin/composer self-update --preview
