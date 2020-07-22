file { 'nginx.conf':
  path => '/etc/nginx/nginx.conf',
  ensure => file,
  source => 'puppet:///modules/nginx/nginx.conf',
  mode => 0644,
  owner => 'root',
  group => 'root'
}

file { 'conf.d/rpms.conf':
  path => '/etc/nginx/conf.d/rpms.conf',
  ensure => file,
  source => 'puppet:///modules/nginx/conf.d_rpms.conf',
  mode => 0644,
  owner => 'root',
  group => 'root'
}

file { 'conf.d/any.conf':
  path => '/etc/nginx/conf.d/any.conf',
  ensure => file,
  source => 'puppet:///modules/nginx/conf.d_any.conf',
  mode => 0644,
  owner => 'root',
  group => 'root'
}

file { 'html/repos/index.html':
  path => '/var/www/html/repos/index.html',
  ensure => file,
  source => 'puppet:///modules/nginx/rpms_index.html',
  mode => 0644,
  owner => 'nginx',
  group => 'nginx'
}

file { 'html/any':
  path => '/var/www/html/any/',
  ensure => directory,
  mode => 0644,
  owner => 'nginx',
  group => 'nginx'
}

file { 'html/any/index.html':
  path => '/var/www/html/any/index.html',
  ensure => file,
  source => 'puppet:///modules/nginx/any_index.html',
  mode => 0644,
  owner => 'nginx',
  group => 'nginx',
  require => File['html/any'],
}

class nginx {
  package{ 'nginx':
    ensure => latest,
  }
  service { 'nginx':
    ensure => running,
    enable => true,
    require => Package['nginx'],
    subscribe => [
      File['nginx.conf'], 
      File['conf.d/rpms.conf'],
      File['conf.d/any.conf'],
      File['html/repos/index.html'],
      File['html/any/index.html'],
    ]
  }
}
