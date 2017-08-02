#!/bin/bash
yum install haproxy -y
setsebool -P haproxy_connect_any=1
number_of_lines=`wc -l /etc/haproxy/haproxy.cfg | cut -d' '  -f1`
n=`expr \$number_of_lines - 62`
tac /etc/haproxy/haproxy.cfg | sed "1,\$n{d}" | tac
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
