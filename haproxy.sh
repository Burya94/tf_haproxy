#!/bin/bash
yum install haproxy -y
setsebool -P haproxy_connect_any=1
cat >> /etc/haproxy/haproxy.cfg << EOF
frontend  to_proxy
    bind ${haproxy_ip}:9200
    default_backend els

backend els
    balance     roundrobin
    server  app1 127.0.0.1:9201 check
    server  app2 127.0.0.1:9202 check
    server  app3 127.0.0.1:9203 check
EOF
systemctl start haproxy
systemctl enable haproxy
sed -i -e "s/#ClientAliveInterval 0/ClientAliveInterval 300/" '/etc/ssh/sshd_config'
sed -i -e "s/#ClientAliveCountMax 2/ClientAliveCountMax 10/" '/etc/ssh/sshd_config'
systemctl restart sshd
