#FROM	httpd	
FROM	ubuntu:latest

# Set non-interactive frontend for automated installations
ENV DEBIAN_FRONTEND=noninteractive

ENV ServerName="Websrv"

WORKDIR /storage

RUN 	apt-get update && apt-get -y upgrade 
RUN     apt-get install -y apache2
RUN     apt-get install -y apache2-utils
RUN 	apt-get install -y curl 
RUN 	apt-get install -y wget 
RUN 	apt-get install -y net-tools


RUN echo 'alias ll="ls -l"' >> ~/.bashrc

EXPOSE 80

COPY httpd.conf /etc/apache2/apache2.conf


CMD ["apachectl", "-D", "FOREGROUND"]
