FROM trafex/alpine-nginx-php7:latest

USER root

ARG OWA_VERSION
ENV OWA_VERSION 1.7.0

# ENV for OWA
ENV OWA_DB_TYPE        "mysql"
ENV OWA_DB_HOST        "mysql:3306"
ENV OWA_DB_NAME        "owa"
ENV OWA_DB_USER        "owa"
ENV OWA_DB_PASSWORD    "owa"
ENV OWA_PUBLIC_URL     "http://localhost:8000/"
ENV OWA_NONCE_KEY      "owanoncekey"
ENV OWA_NONCE_SALT     "owanoncesalt"
ENV OWA_AUTH_KEY       "owaauthkey"
ENV OWA_AUTH_SALT      "owaauthsalt"
ENV OWA_ERROR_HANDLER  "development"
ENV OWA_LOG_PHP_ERRORS "false"
ENV OWA_CACHE_OBJECTS  "true"

RUN apk --no-cache add php7-zip php7-simplexml php7-imap php7-mbstring curl && \
	rm /var/www/html/* && \
	wget https://github.com/Open-Web-Analytics/Open-Web-Analytics/archive/${OWA_VERSION}.tar.gz  -O /owa.tar.gz && \
	mkdir -p /var/lib/php/session && \
	mkdir -p /var/www/html/webserver-configs && \
	tar zxf /owa.tar.gz --directory /var/www/ && \
	mv /var/www/Open-Web-Analytics-${OWA_VERSION} /var/www/owa && \
	rm /owa.tar.gz && \
    ln -s /var/www/html/webserver-configs/owa-nginx.conf /etc/nginx/conf.d/owa-nginx.conf
ADD owa-nginx.conf /var/www/owa/webserver-configs/owa-nginx.conf
ADD owa-nginx.conf /var/www/html/webserver-configs/owa-nginx.conf
ADD startup.sh /startup.sh
RUN chmod a+rx /startup.sh && \
	chown nobody:nobody /startup.sh && \
	chown -R nobody:nobody /var/www/owa && \
	chown -R nobody:nobody /var/www/html && \
	chown -R nobody:nobody /var/lib/php/session

USER nobody
CMD [ "/startup.sh" ]
