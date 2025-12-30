FROM postgres:16

# Minimal "security": default postgres image, no SSL, password via env var
ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=appdb

# Directory for logs inside container
ENV PGLOGDIR=/var/log/postgresql

RUN mkdir -p ${PGLOGDIR} && chown -R postgres:postgres ${PGLOGDIR}

# Init script to configure logging and separate log directory
# This runs only on first init of the data directory
COPY init-logging.sh /docker-entrypoint-initdb.d/01-init-logging.sh
RUN chmod +x /docker-entrypoint-initdb.d/01-init-logging.sh