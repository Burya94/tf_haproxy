#!/bin/bash
yum install java -y
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat >> /etc/yum.repos.d/logstash.repo << EOF
[logstash-2.2]
name=logstash repository for 2.2 packages
baseurl=http://packages.elasticsearch.org/logstash/2.2/centos
gpgcheck=1
gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
enabled=1
EOF
yum install logstash -y
