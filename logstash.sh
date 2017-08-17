#!/bin/bash
mount /dev/xvda2 /mnt
dd if=/dev/zero of=/mnt/swapfile bs=1M count=2048
chown root:root /mnt/swapfile
chmod 600 /mnt/swapfile
mkswap /mnt/swapfile
swapon /mnt/swapfile
echo "/mnt/swapfile swap swap defaults 0 0" >> /etc/fstab
echo "vm.swappiness = 100" >> /etc/sysctl.conf
sysctl -p
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
