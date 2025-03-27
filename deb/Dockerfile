FROM	debian:bookworm-slim
RUN 	apt-get update &&  
 		apt-get install -y curl \
		apt-get install -y wget \
		apt-get install -y apt-file \
		apt-get install -y net-tools \
		apt-get install -y iproute2 \
		apt-get install -y openssh-server 
 
RUN echo 'alias ll="ls -l"' >> ~/.bashrc

#CAT other/shell >>  ~/.bashrc

#Config SSH if wanted 
RUN 	mkdir -p /var/run/sshd
RUN 	echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

#Expose port 22 (so you can ssh to the container)
EXPOSE 22

#RUN SSHD
CMD ["/usr/sbin/sshd","-D"]

COPY	etc/resolv.conf /etc/.
