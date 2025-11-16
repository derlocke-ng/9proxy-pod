FROM fedora:latest

ENV container podman

# Install systemd, OpenSSH server and wget
RUN dnf -y install systemd openssh-server wget && \
    dnf clean all

# Install 9proxy RPM
RUN wget -O /tmp/9proxy.rpm https://static.9proxy-cdn.net/download/latest/linux/9proxy-linux-redhat-amd64.rpm && \
    dnf -y install /tmp/9proxy.rpm && \
    rm -f /tmp/9proxy.rpm

# Create non-root user 'user' and set password
RUN useradd -m -s /bin/bash user && \
    echo "user:9proxy" | chpasswd

# Configure SSH for password authentication (disable root login)
RUN sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config

# Enable SSH and 9proxyd services
RUN systemctl enable sshd && \
    systemctl enable 9proxyd

STOPSIGNAL SIGRTMIN+3

# Expose SSH port and 9proxy TCP ports 60000-60009
EXPOSE 22
EXPOSE 60000-60009

# Default command: run systemd
CMD ["/usr/sbin/init"]
