## Alpine docker with lamp

This is a docker file that take an image from alpine linux and create a lamp stack

## Instalation
### grab from docker hub
```
docker run -d -v /path/to/project:/var/www/localhost/htdocs/ -e MYSQL_ROOT_PASSWORD=password -p 80:80 -p 3306:3306 --name lamp glats/alpine-lamp
```

### Run you own image

```  
git clone https://github.com/glats/alpine-docker-lamp
```
