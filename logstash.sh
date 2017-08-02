#!/bin/bash
yum install wget -y
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
yum install java -y
#_CONFIG________________________________________
cat >> /etc/logstash/ << EOF
input{
    file{
        type => "some_access_log"
        path => [ "/var/log/logstash/logstash.log"]
        start_position => "end"
        stat_interval => 1
        discover_interval => 30
    }
}
filter{

}
output{
    elasticsearch {
        hosts => [ "${proxy_dns}:9200" ]
    }
}
EOF
systemctl start logstash
systemctl enable logstash
