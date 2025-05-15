FROM debian:bullseye-slim

# Install required dependencies
RUN apt update && \
    apt install -y gnupg2 curl lsb-release ca-certificates

# Add FRR repo and install FRR with vtysh
RUN curl -s https://deb.frrouting.org/frr/keys.asc | apt-key add - && \
    echo "deb https://deb.frrouting.org/frr $(lsb_release -s -c) frr-stable" > /etc/apt/sources.list.d/frr.list && \
    apt update && \
    apt install -y frr frr-pythontools

# SSH setup
RUN apt install -y openssh-server iproute2 net-tools iputils-ping && \
    mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Enable FRR daemons (zebra and ospfd)
RUN sed -i 's/zebra=no/zebra=yes/' /etc/frr/daemons && \
    sed -i 's/ospfd=no/ospfd=yes/' /etc/frr/daemons

# Ensure startup script exists
COPY init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 22
CMD ["/usr/local/bin/init.sh"]
