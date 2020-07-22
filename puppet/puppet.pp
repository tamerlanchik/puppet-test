$user = 'kochnovandrey2013'
$home = "/home/${user}"

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

file { 'conf.d/any.conf':
  path => '/etc/nginx/conf.d/any.conf',
  ensure => file,
  source => 'puppet:///files/nginx/conf.d_any.conf',
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
  source => 'puppet:///files/any_index.html',
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

class openvpn {
  package { 'epel-release':
    ensure => latest,
  }
  package { 'openvpn':
    ensure => latest,
    require => Package['epel-release']
  }
  package { 'zip':
    ensure => latest,
  }
  package { 'unzip':
    ensure => latest,
  }
  package { 'wget':
    ensure => latest,
  }
  file { '/etc/openvpn':
    ensure => directory,
    mode => 644,
    owner => $user,
  }
  file { '/etc/openvpn/keys':
    ensure => directory,
    mode => 644,
    owner => $user,
    require => File['/etc/openvpn']
  }
  file { 'install_openvpn.sh':
    path => "${home}/install_openvpn.sh",
    ensure => file,
    source => 'puppet:///files/install_openvpn.sh',
    mode => 0755,
    owner => $user,
    require => [
      File['/etc/openvpn/keys'],
      Package['wget'],
      Package['zip'],
      Package['unzip'],
      Package['openvpn'],
    ]
  }
  exec { 'install openvpn':
    require => File['install_openvpn.sh'],
    command => "${home}/install_openvpn.sh"
  }

}

node 'instance-1' {
  include nginx
  include openvpn
}
