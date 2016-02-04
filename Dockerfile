from microimages/alpine

maintainer william <wlj@nicescale.com>

label service=php

run apk-install php-apache2 php-curl php-sockets php-cli php-openssl php-mysqli php-gd \
  && mkdir /run/apache2

copy apache2-foreground /usr/bin/
copy docker-php-ext-install /usr/bin/

workdir /app

run mv /var/www/localhost/htdocs/* /app/ \
	&& rmdir /var/www/localhost/htdocs \
	&& ln -s /app /var/www/localhost/htdocs

expose 80

cmd ["apache2-foreground"]
