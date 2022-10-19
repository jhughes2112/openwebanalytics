FROM trafex/alpine-nginx-php7:latest

USER root

ARG OWA_VERSION
ENV OWA_VERSION 1.7.7

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
	wget https://github.com/Open-Web-Analytics/Open-Web-Analytics/releases/download/${OWA_VERSION}/owa_${OWA_VERSION}_packaged.tar	-O /owa.tar && \
	mkdir -p /var/lib/php/session && \
	mkdir -p /var/www/html/webserver-configs && \
	mkdir -p /var/www/owa && \
	tar xf /owa.tar --directory /var/www/owa && \
	rm /owa.tar && \
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
EXPOSE 8000
CMD [ "/startup.sh" ]
