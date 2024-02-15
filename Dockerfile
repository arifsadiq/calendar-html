FROM httpd:latest

COPY cal.html /usr/local/apache2/htdocs/
COPY adv-cal.html /usr/local/apache2/htdocs/

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]