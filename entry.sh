#!/bin/sh

mkdir -p /usr/share/webapps/ && cd /usr/share/webapps/ && \
    wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz > /dev/null 2>&1 && \
    tar -xzvf phpMyAdmin-4.9.0.1-all-languages.tar.gz > /dev/null 2>&1 && \
    mv phpMyAdmin-4.9.0.1-all-languages phpmyadmin && \
    chmod -R 777 /usr/share/webapps/ && \
    ln -s /usr/share/webapps/phpmyadmin/ /var/www/localhost/htdocs/phpmyadmin

# start apache
echo "Starting httpd"
httpd
echo "Done httpd"


# check if mysql data directory is nuked
# if so, install the db
echo "Checking /var/lib/mysql folder"
if [ ! -f /var/lib/mysql/ibdata1 ]; then 
    echo "Installing db"
    mariadb-install-db --user=mysql --ldata=/var/lib/mysql > /dev/null
    echo "Installed"
fi;

# from mysql official docker repo
if [ -z "$MYSQL_ROOT_PASSWORD" -a -z "$MYSQL_RANDOM_ROOT_PASSWORD" ]; then
			echo >&2 'error: database is uninitialized and password option is not specified '
			echo >&2 '  You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_RANDOM_ROOT_PASSWORD'
			exit 1
fi

# random password
if [ ! -z "$MYSQL_RANDOM_ROOT_PASSWORD" ]; then
    echo "Using random password"
    MYSQL_ROOT_PASSWORD="$(pwgen -1 32)"
    echo "GENERATED ROOT PASSWORD: $MYSQL_ROOT_PASSWORD"
    echo "Done"
fi

tfile=`mktemp`
if [ ! -f "$tfile" ]; then
    return 1
fi

cat << EOF > $tfile
    USE mysql;
    DELETE FROM user;
    FLUSH PRIVILEGES;
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD" WITH GRANT OPTION;
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
    UPDATE user SET password=PASSWORD("") WHERE user='root' AND host='localhost';
    FLUSH PRIVILEGES;
EOF

echo "Querying user"
/usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tfile
rm -f $tfile
echo "Done query"

# start mysql
# nohup mysqld_safe --skip-grant-tables --bind-address 0.0.0.0 --user mysql > /dev/null 2>&1 &
echo "Starting mariadb database"
exec /usr/bin/mysqld --user=root --bind-address=0.0.0.0
