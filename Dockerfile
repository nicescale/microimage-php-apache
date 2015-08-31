from microimages/alpine

maintainer william <wlj@nicescale.com>

label service=php

run apk add --update php-apache2 php-curl php-sockets php-cli php-openssl

copy apache2-foreground /usr/bin/

run ln -s /var/www/localhost/htdocs /app

workdir /app

expose 80

cmd ["apache2-foreground"]
