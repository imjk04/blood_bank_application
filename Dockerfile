# Use the official PHP image version 7.2 with Apache pre-installed
FROM php:7.2-apache

# Install the mysqli extension so PHP can connect to MySQL databases
RUN docker-php-ext-install mysqli

# Copy all files from the current directory on your machine
# into the Apache web root inside the container (/var/www/html/)
COPY . /var/www/html/
