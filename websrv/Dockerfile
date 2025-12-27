FROM debian:stable-slim

# Install Apache + logrotate
RUN apt-get update && \
    apt-get install -y apache2 logrotate && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable directory listing + symlink following
RUN sed -i 's/Options Indexes FollowSymLinks/Options Indexes FollowSymLinks/' /etc/apache2/apache2.conf && \
    a2enmod autoindex

# Explicit ServerName to avoid LLG warnings
RUN echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf && \
    a2enconf servername

# Configure logrotate for Apache logs
RUN cat << 'EOF' > /etc/logrotate.d/apache2
/var/log/apache2/*.log {
    daily
    rotate 7
    missingok
    notifempty
    compress
    delaycompress
    sharedscripts
    postrotate
        /usr/sbin/apachectl graceful > /dev/null 2>&1 || true
    endscript
}
EOF

# Ensure Apache logs directory exists (will be bind-mounted)
RUN mkdir -p /var/log/apache2

# Expose port 80
EXPOSE 80

# Run Apache in foreground
CMD ["apachectl", "-D", "FOREGROUND"]