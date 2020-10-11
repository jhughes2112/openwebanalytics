This is a very lightweight, simple Alpine/Nginx/PHP7 Docker image running Open Web Analytics.

The server does not run as "root", instead it runs as "nobody".  That also means it cannot bind to port 80, so all traffic comes into the container on port 8000.

# Usage

The Docker image is configured so the original install is at /var/www/owa and is automatically copied on startup to /var/www/html if it isn't already present.  
That way, it will startup and run cleanly every time without a mounted volume, or you can mount an empty volume at /var/www/html and it'll copy itself into place on the first run only.
Also, /var/www/html/webserver-configs/owa-nginx.conf is the Nginx configuration file that is used to host the site.  Since you can't restart Nginx inside a docker container, if you want to tweak the config, just edit the file and restart the container (assuming you have a volume mounted there to retain file changes).

## Docker

### To run:

The simplest way to run this image with docker alone is:

```
docker network create owa
docker run -d --rm -p 3306:3306 --network owa --name mysql -e MYSQL_ROOT_PASSWORD=owa -e MYSQL_DATABASE=owa -e MYSQL_USER=owa -e MYSQL_PASSWORD=owa -v /your/local/mysql/folder:/var/lib/mysql mysql:5.7
docker run -d --rm -p 8000:8000 --network owa --name owa -v /your/local/folder:/var/www/html jhughes2112/openwebanalytics
```

This will run Open Web Analytics on [http://localhost:8000/](http://localhost:8000/)

This will do the following:
* Open port 8000 for http access on localhost.
* Create a local network so OWA can talk to the MySQL instance directly.
* Run MySQL with a new user named 'owa', while setting both this user and root user's password to 'owa'.  Clearly not very secure.
* The -v argument maps a local folder to a folder inside each of the running containers.  If you don't care about the data and just want to try it out, you can remove these.  The data will be lost when you shut them down, though.

To test it out, tell it that the hostname of the MySQL database is "mysql", the database name is "owa", user is "owa" and password is "owa".

### To shut down:
```
docker stop mysql
docker stop owa
docker network rm owa
```

### Building the image

If you want to try building this image, clone down this repo, go to this folder in your shell and type:
```
docker build . -t my-owa-image:latest
```

You can then substitute my-owa-image:latest at the end of the docker command above instead of jhughes2112/openwebanalytics.

Note: **** If you update to a newer MySQL instance than 5.7, you will not be able to connect to it without updating to PHP7.4 as well. ****

Enjoy!