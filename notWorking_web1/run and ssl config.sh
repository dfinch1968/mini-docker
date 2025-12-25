# Create SSL
openssl req -x509 -newkey rsa:4096 -keyout myweb.crt -out myweb.key -days 36500 -nodes -subj "/CN=myweb.com"

# Build it
docker build -t debweb .

# Run it
docker run -d --restart=always -p 80:80 -p 443:443 -v /Volumes/Lacie/xxPersist/xxwww:/var/www/html  --name=web debweb

# Connect to troubleshoot
docker exec -it web /bin/bash

# more troublshooting
docker run -it --entrypoint /bin/bash p 80:80 -p 443:443 -v /Volumes/Lacie/xxPersist/xxwww:/var/www/html debweb