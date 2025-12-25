FROM debian:stable-slim

# Install Apache, SSL support, and network tools (ping, netstat)
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      apache2 \
      openssl \
      iputils-ping \
      net-tools \
      && rm -rf /var/lib/apt/lists/*

# Enable Apache modules needed for SSL and directory listing
RUN a2enmod ssl headers rewrite && \
    a2enmod autoindex

# Create SSL cert
RUN mkdir -p /etc/apache2/ssl && \
    openssl req -x509 -nodes -days 365 \
      -subj "/C=US/ST=Florida/L=FortMyers/O=LocalDev/OU=Dev/CN=localhost" \
      -newkey rsa:2048 \
      -keyout /etc/apache2/ssl/apache.key \
      -out /etc/apache2/ssl/apache.crt

#  Copy SSL 
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY default-ssl.conf /etc/apache2/sites-available/default-ssl.conf

# Set global ServerName directive
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Enable the SSL site and default site
RUN a2ensite default-ssl.conf && a2ensite 000-default.conf

# Expose HTTPS
EXPOSE 443

# Run Apache in foreground
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]