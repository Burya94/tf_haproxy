#!/bin/bash
yum install wget -y
cd /opt && wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.tar.gz"
cd /opt && tar xzvf jdk-8u141-linux-x64.tar.gz
echo "export JAVA_HOME=/opt/jdk1.8.0_141/" >> /root/.bash_profile
echo "export PATH=${PATH}:${JAVA_HOME}bin/" >> /root/.bash_profile
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
#_)________________________________________
input{
    file{
        type => "some_access_log"
        path => [ "/var/log/messages"]
        start_position => "end"
        stat_interval => 1
        discover_interval => 30
    }
}
filter{

}
output{
    stdout{
        type => "naproxy"
        host => "10.231.230.199"
        port => "9200"
    }
}
