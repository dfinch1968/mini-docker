# Use Debian slim as base
FROM debian:12-slim

# Metadata
LABEL maintainer="dfinch68@outlook.com"
ENV DEBIAN_FRONTEND=noninteractive

# Install Apache, SSL, and utilities (ping, netstat)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    apache2 \
    openssl \
    iputils-ping \
    net-tools \
    procps \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Enable required Apache modules
RUN a2enmod ssl \
 && a2enmod headers \
 && a2enmod autoindex \
 && a2enmod rewrite

# Copy site config and entrypoint
COPY ./apache-site.conf /etc/apache2/sites-available/000-default.conf
COPY ./apache-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set global ServerName directive
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Expose HTTP and HTTPS
EXPOSE 80 443

# Use a non-root working dir for runtime operations
WORKDIR /var/www/html

# Entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["apache2ctl", "-D", "FOREGROUND"]