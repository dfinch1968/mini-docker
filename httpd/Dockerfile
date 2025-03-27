#FROM	httpd	
FROM	debian:bookworm-slim
RUN 	apt-get update && apt-get -y upgrade 
RUN 	apt-get install -y curl 
RUN     apt-get install -y lighttpd
RUN 	apt-get install -y wget 
 
RUN echo 'alias ll="ls -l"' >> ~/.bashrc

EXPOSE 80
COPY httpd.conf /etc/httpd/.


