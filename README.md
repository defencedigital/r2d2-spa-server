# spa-server

As of May 2020 we have switched to nginx.

* SPA application files should be placed in `/var/www/html`
* If `DISABLE_SSL_REDIRECT` is set to true, the redirection of non-ssl to ssl will be removed, which should help during the local development process.

### SSL configuration
* SSL certificates definitions can be set via include file.
* Include file path `/etc/nginx/include/ssl-include.conf` can be mounted as config map in k8s world