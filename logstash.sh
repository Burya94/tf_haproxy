#!/bin/bash
timedatectl set-timezone Europe/Kiev
rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum -y install puppet-agent
cat >> /etc/puppetlabs/puppet/puppet.conf << EOF
[main]
server = ${dns_name}
environment = logstash
EOF
cat >> /etc/hosts << EOF
${puppet_ip} ${dns_name}
EOF
systemctl start puppet
#add  role
cat >> /root/role.rb << EOF
Facter.add(:role) do
  setcode do
    'logstash'
  end
end
EOF
echo "export FACTERLIB=/root/" >> /root/.bash_profile

#-----------------------------------------------------------
