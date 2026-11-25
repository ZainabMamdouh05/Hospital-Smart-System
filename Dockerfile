FROM httpd:2.4

WORKDIR /usr/local/apache2/htdocs

COPY src/frontend/ /usr/local/apache2/htdocs/

EXPOSE 80

CMD ["httpd-foreground"]