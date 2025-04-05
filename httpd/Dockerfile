#FROM	httpd	
FROM	debian:bookworm-slim
RUN 	apt-get update && apt-get -y upgrade 
RUN 	apt-get install -y curl 
RUN     apt-get install -y apache2
RUN     apt-get install -y apache2-utils
RUN 	apt-get install -y wget 
RUN 	apt-get install -y net-tools
RUN     apt-get clean
 
RUN echo 'alias ll="ls -l"' >> ~/.bashrc

EXPOSE 80
#COPY httpd.conf /etc/httpd/.


CMD [“apache2ctl”, “-D”, “FOREGROUND”]


