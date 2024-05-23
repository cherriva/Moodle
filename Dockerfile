# Usa una imagen base de PHP con Apache
FROM php:7.4-apache

# Instala las extensiones de PHP necesarias y default-mysql-client
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    libicu-dev \
    cron \
    default-mysql-client \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mbstring zip mysqli pdo pdo_mysql intl

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copia los archivos de configuración y scripts
COPY config-docker.php /var/www/html/config-docker.php
COPY init.sh /init.sh
RUN chmod +x /init.sh

# Crear un volumen para el código de Moodle
VOLUME /var/www/html/moodle

# Exponer el puerto 80 para acceder a Moodle
EXPOSE 80

# Ejecuta el script de inicialización al iniciar el contenedor
CMD ["/init.sh"]
