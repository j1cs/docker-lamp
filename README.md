## Alpine docker with lamp

This is a docker file that take an image from alpine linux and create a lamp stack

## Instalation
### grab from docker hub
```
docker run -d -v /path/to/project:/var/www/localhost/htdocs/ -e MYSQL_ROOT_PASSWORD=password -p 80:80 -p 3306:3306 --name lamp glats/alpine-lamp
```

### Run you own image

```  
git clone https://github.com/glats/alpine-lamp && cd alpine-docker-lamp/
```

### Build the image
```
docker buiuld -t username/alpine-lamp .
```

### Run it

```
docker run -d -v /path/to/project:/var/www/localhost/htdocs/ -e MYSQL_ROOT_PASSWORD=password -p 80:80 -p 3306:3306 --name lamp glats/alpine-lamp
```

## Troubleshooting
If you get a "forbidden error 403"
in your project run:
```
sudo chmod -Rf 755 /path/to/project
``` 
If missing some lib for php please let me know or create a pull request
