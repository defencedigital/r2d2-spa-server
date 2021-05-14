FROM nginx:1.20

ADD static/vhost.conf /etc/nginx/conf.d/default.conf
ADD static/ssl-include.conf /etc/nginx/include/ssl-include.conf
# SSL certification generation:
# CERT: sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
# DHPARAM openssl dhparam -out ssl/dhparam.pem 2048
ADD certs/self-signed.crt /etc/ssl/certs-custom/self-signed.crt
ADD certs/self-signed.key /etc/ssl/certs-custom/self-signed.key
ADD certs/dhparam.pem /etc/ssl/certs-custom/dhparam.pem
RUN nginx -t
# COPY spa/. /var/www/html