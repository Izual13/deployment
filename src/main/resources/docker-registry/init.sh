yum install -y docker httpd-tools
curl -L "https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
mkdir -p /registry/data
mkdir -p /registry/auth
mkdir -p /certs && openssl req -newkey rsa:4096 -nodes -sha256 -keyout /certs/domain.key -x509 -days 365 -out /certs/domain.crt


mkdir -p /etc/docker/certs.d/${host}
cp /certs/domain.crt /etc/docker/certs.d/${host}/ca.crt
chmod -R 700 /etc/docker/certs.d/${host}
cd /etc/docker/certs.d/${host}
ls -l /etc/docker/certs.d/${host}
htpasswd -bc /registry/auth/htpasswd ${user} ${password}

chcon -Rt svirt_sandbox_file_t /certs/
chcon -Rt svirt_sandbox_file_t /registry/data
chcon -Rt svirt_sandbox_file_t /registry/auth

service docker start