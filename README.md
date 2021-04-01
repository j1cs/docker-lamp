## Docker with LAMP stack based on Alpine Linux

This docker contain a LAMP stack installed from scratch

## Installation
### Grab from docker hub
```
docker run -d -v /path/to/project:/var/www/localhost/htdocs/ -v /path/to/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=password -p 80:80 -p 3306:3306 --name lamp glats/alpine-lamp
```

### Run you own image

```  
git clone https://github.com/glats/alpine-lamp && cd alpine-lamp/
```

### Build the image
```
docker build -t $USER/alpine-lamp .
```

### Run it

```
docker run -d -v /path/to/project:/var/www/localhost/htdocs/ -e MYSQL_ROOT_PASSWORD=password -p 80:80 -p 3306:3306 --name lamp $USER/alpine-lamp
```

### Connect to MariaDB
To use this you need to install mysql/mariadb cli client
```
mysql -uroot -ppassword -h 127.0.0.1
```

### PhpMyAdmin

If you want to use phpMyAdmin use the branch called: **phpmyadmin-feature**


## Troubleshooting
If you get a "forbidden error 403"
Fix it with:
```
sudo chmod -Rf 755 /path/to/project
``` 
If missing libs please let me know or create a pull request

## Repos
https://hub.docker.com/r/glats/alpine-lamp  
https://github.com/glats/alpine-lamp
