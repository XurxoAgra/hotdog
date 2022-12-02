FROM php:8.1.13-apache-buster

# Update
RUN apt-get -y update --fix-missing && \
    apt-get upgrade -y && \
    apt-get --no-install-recommends install -y apt-utils && \
    rm -rf /var/lib/apt/lists/*

# Install useful tools and install important libaries
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install vim zlib1g-dev libzip-dev && \
    apt-get -y --no-install-recommends install --fix-missing curl libcurl4 libcurl4-openssl-dev zip openssl libssl-dev

# Install lessc and yui-compressor (no se consigió hacer funcionar, pero por tiempo... ¬_¬)
#RUN apt-get -y update --fix-missing && \
#    apt-get -y --no-install-recommends install nodejs npm yui-compressor
#
#RUN npm install -g less

# Other PHP7 Extensions
RUN docker-php-ext-install pdo && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install mysqli && \
    docker-php-ext-install curl && \
    docker-php-ext-install zip && \
    docker-php-ext-install gettext && \
    docker-php-ext-install exif

RUN docker-php-ext-configure opcache --enable-opcache && \
    docker-php-ext-install opcache

# Enable apache modules
RUN a2enmod rewrite headers

# Change usermod
ARG USER_ID=1001
ARG GROUP_ID=1001
RUN usermod -u ${USER_ID} www-data
RUN groupmod -g ${GROUP_ID} www-data
RUN usermod -d /home/www-data www-data
RUN mkdir /home/www-data

# Entrypoint
ADD entrypoint.sh /home/www-data/entrypoint.sh

RUN chmod +x /home/www-data/entrypoint.sh
RUN chown -R www-data:www-data /home/www-data

CMD ["/home/www-data/entrypoint.sh", "apache2-foreground"]
