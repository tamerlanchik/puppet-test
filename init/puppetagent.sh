#!/bin/bash
# installing puppet-agent

server=${1?"Need puppetserver address at \$1"}
certname=${2?"Need puppet-slave host name (for cert) at \$2"}
server_ip=$3
environment=${4:-"production"}
echo "Installing puppet-agent..."
sudo rpm -Uvh http://yum.puppetlabs.com/puppet-release-el-7.noarch.rpm
echo "Puppet repo added"
sudo yum install -y puppet-agent epel-release
echo "Installed: puppet-agent"
export PATH=/opt/puppetlabs/bin:$PATH

sudo cat > /etc/puppetlabs/puppet/puppet.conf <<- EOF
[main]
server = ${server}

[agent]
certname = ${certname}
autosign = true
environment = ${environment}
splay = false
listen = true
EOF

if [ $server_ip ne '']; then
  echo "${server_ip}  ${server}" >> /etc/hosts;
fi
echo "Puppet-agent config filled"

puppet ssl bootstrap
echo "Certificate signed"
echo "export PATH=$PATH:/opt/puppetlabs/bin" >> ~/.bash_profile
echo "Run 'puppetserver ca sign --certname <name>' on master and 'puppet ssl bootstrap' here"
