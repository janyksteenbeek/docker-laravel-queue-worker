FROM php:7.3-alpine

LABEL maintainer="Janyk Steenbeek <info@janyksteenbeek.nl>" \
		version.image="v4.1" \
		version.php=$PHP_VERSION \
		description="A supervisor configured to run with laravel artisan queue:work or artisan horizon command"

ENV QUEUE_CONNECTION=redis
ENV QUEUE_NAME=default
ENV LARAVEL_HORIZON=false
ENV MEMORY_LIMIT=512

# Install pdo if you want to use database queue and install supervisor
RUN apk add --update libxml2-dev && docker-php-ext-install pdo pdo_mysql pcntl posix soap tokenizer json xml mbstring  \
	&& apk add --update supervisor && rm -rf /tmp/* /var/cache/apk/*

# Define working directory
WORKDIR /etc/supervisor/conf.d

# Use local configuration
COPY laravel-worker.conf.tpl /etc/supervisor/conf.d/laravel-worker.conf.tpl
COPY laravel-horizon.conf.tpl /etc/supervisor/conf.d/laravel-horizon.conf.tpl
COPY custom-php.ini.tpl /opt/etc/custom-php.ini.tpl

# Copy scripts
COPY init.sh /usr/local/bin/init.sh

VOLUME /var/www/app

# Run supervisor
ENTRYPOINT ["/bin/sh", "/usr/local/bin/init.sh"]
