#!/bin/sh

# start apache
httpd

# check if mysql data directory is nuked
# if so, install the db
if [ ! -f /var/lib/mysql/ibdata1 ]; then 
    mysql_install_db --user=root > /dev/null
fi;

if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
fi

# from mysql official docker repo
if [ -z "$MYSQL_ROOT_PASSWORD" -a -z "$MYSQL_RANDOM_ROOT_PASSWORD" ]; then
			echo >&2 'error: database is uninitialized and password option is not specified '
			echo >&2 '  You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_RANDOM_ROOT_PASSWORD'
			exit 1
fi

# random password
if [ ! -z "$MYSQL_RANDOM_ROOT_PASSWORD" ]; then
    MYSQL_ROOT_PASSWORD="$(pwgen -1 32)"
    echo "GENERATED ROOT PASSWORD: $MYSQL_ROOT_PASSWORD"
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

/usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tfile
rm -f $tfile

# start mysql
# nohup mysqld_safe --skip-grant-tables --bind-address 0.0.0.0 --user mysql > /dev/null 2>&1 &
exec /usr/bin/mysqld --user=root --bind-address=0.0.0.0
