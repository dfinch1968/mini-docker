## OS
FROM	debian:bookworm-slim
RUN 	apt-get update
RUN 	apt-get install curl -y
RUN     apt-get install wget -y
RUN     apt-get install apt-file -y
RUN     apt-file update
RUN	apt-get install iproute2 -y
RUN     apt-get install openssh-server -y
RUN 	echo 'alias ll="ls -l"' >> ~/.bashrc

#Add (your) ADM account
RUN 	useradd -m -G root -s /bin/bash adm_dfinch2
RUN 	echo 'alias ll="ls -l"' >> /home/adm_dfinch2/.bashrc

#Change passwords
RUN     echo "root:B1@ck83rry" | chpasswd

#Config SSH if wanted
RUN 	mkdir -p /var/run/sshd
RUN 	echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

#Expose port 22 (so you can ssh to the container)
EXPOSE 22

#RUN SSHD
CMD ["/usr/sbin/sshd","-D"]


## mySQL
COPY	etc/resolv.conf /etc/.

FROM mysql:latest

ENV MYSQL_ROOT_PASSWORD=root

COPY ./speed_db.sql /docker-entrypoint-initdb.d/

EXPOSE 3306