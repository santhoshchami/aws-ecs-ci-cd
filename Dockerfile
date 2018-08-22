#Docker file to build image
FROM 684311504653.dkr.ecr.us-east-1.amazonaws.com/pulseid-task
MAINTAINER Test httpd
COPY ./public-html/index.html /usr/share/nginx/html/index.html
EXPOSE 80
