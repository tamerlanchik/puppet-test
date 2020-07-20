file { 'nginx.conf':
  path => '/etc/nginx/nginx.conf',
  ensure => file,
  source => 'puppet:///files/nginx/nginx.conf',
  mode => 0644,
  owner => 'root',
  group => 'root'
}

file { 'conf.d/rpms.conf':
  path => '/etc/nginx/conf.d/rpms.conf',
  ensure => file,
  source => 'puppet:///files/nginx/conf.d_rpms.conf',
  mode => 0644,
  owner => 'root',
  group => 'root'
}

file { 'html/repos/index.html':
  path => '/var/www/html/repos/index.html',
  ensure => file,
  source => 'puppet:///files/rpms_index.html',
  mode => 0644,
  owner => 'nginx',
  group => 'nginx'
}

class nginx {
  package{ 'nginx':
    ensure => latest,
  }
  service { 'nginx':
    ensure => stopped,
    enable => true,
    require => Package['nginx'],
    subscribe => File['nginx.conf'],
    subscribe => File['conf.d/rpms.conf'],
  }
}

node 'puppetmaster' {
  include nginx
}