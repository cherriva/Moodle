#!/bin/bash

# Ruta al directorio de Moodle
MOODLE_DIR=/var/www/html/moodle

# Clona el repositorio de Moodle solo si no existe
if [ ! -d "$MOODLE_DIR" ]; then
    git clone -b MOODLE_400_STABLE https://github.com/moodle/moodle.git $MOODLE_DIR
    cd $MOODLE_DIR
    composer install
    cp /var/www/html/config-docker.php $MOODLE_DIR/config.php
    chown -R www-data:www-data $MOODLE_DIR
fi

# Esperar a que la base de datos esté disponible
echo "Esperando a la base de datos..."
while ! mysqladmin ping -h"db" --silent; do
    sleep 1
done

# Ejecutar el instalador de Moodle
cd $MOODLE_DIR
php admin/cli/install_database.php --agree-license --fullname="My Moodle Site" --shortname="moodle" --adminuser=admin --adminpass=adminpassword --adminemail=admin@example.com

# Levantar Apache en primer plano
apache2-foreground
