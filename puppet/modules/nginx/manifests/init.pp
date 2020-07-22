class nginx {
  $files = "puppet:///modules/nginx"
file { 'nginx.conf':
  path => '/etc/nginx/nginx.conf',
  ensure => file,
  source => "${files}/nginx.conf",
  mode => 0644,
  owner => 'root',
  group => 'root'
}

file { 'conf.d/rpms.conf':
  path => '/etc/nginx/conf.d/rpms.conf',
  ensure => file,
  source => "${files}/conf.d_rpms.conf",
  mode => 0644,
  owner => 'root',
  group => 'root'
}

file { 'conf.d/any.conf':
  path => '/etc/nginx/conf.d/any.conf',
  ensure => file,
  source => "${files}/conf.d_any.conf",
  mode => 0644,
  owner => 'root',
  group => 'root'
}

file { 'html/repos/index.html':
  path => '/var/www/html/repos/index.html',
  ensure => file,
  source => "${files}/rpms_index.html",
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
  source => "${files}/any_index.html",
  mode => 0644,
  owner => 'nginx',
  group => 'nginx',
  require => File['html/any'],
}

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
