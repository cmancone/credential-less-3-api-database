#!/bin/bash
sh -c "echo '${akeyless_ca_public_key}' >> /etc/ssh/trusted"
sh -c "echo 'TrustedUserCAKeys /etc/ssh/trusted' >> /etc/ssh/sshd_config"
systemctl restart sshd
apt update
apt install -y mariadb-client-core-10.3
