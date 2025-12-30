FROM fedora:latest

# Environment
ENV MARIADB_VERSION=10.11 \
    MYSQL_DATADIR=/var/lib/mysql \
    MYSQL_LOGDIR=/var/log/mysql

# Install MariaDB server, logrotate, cron, and basic tools
RUN dnf -y install \
      mariadb-server \
      mariadb \
      cronie \
      logrotate \
      tzdata \
      vim-minimal \
      net-tools \
      iproute \
      which \
      less \
      procps-ng \
    && dnf clean all

# Create mysql user/group if not already present (usually created by package)
RUN mkdir -p ${MYSQL_DATADIR} ${MYSQL_LOGDIR} \
    && chown -R mysql:mysql ${MYSQL_DATADIR} ${MYSQL_LOGDIR} \
    && chmod 750 ${MYSQL_DATADIR} ${MYSQL_LOGDIR}

# MariaDB config: low buffer pool, logs, LAN access
COPY mariadb.cnf /etc/my.cnf.d/mariadb.cnf

# Logrotate configuration for MariaDB logs
COPY mariadb-logrotate /etc/logrotate.d/mariadb

# Initialization script: create database "speed" and user "darren"
COPY init-db.sql /docker-entrypoint-initdb.d/init-db.sql

# Simple entrypoint script to:
#  - initialize data dir if empty
#  - start cron for logrotate
#  - start MariaDB in foreground
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 3306

VOLUME ["${MYSQL_DATADIR}", "${MYSQL_LOGDIR}"]

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["mysqld"]