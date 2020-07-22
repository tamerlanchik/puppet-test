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
    source => 'puppet:///modules/install_openvpn.sh',
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
  # exec { 'install openvpn':
  #   require => File['install_openvpn.sh'],
  #   command => "${home}/install_openvpn.sh"
  #   subscribe => File['install_openvpn.sh']
  # }
  file { '/etc/openvpn/server.conf':
    path => "/etc/openvpn/server.conf",
    ensure => file,
    source => 'puppet:///modules/openvpn/server.conf',
    mode => 0755,
    owner => $user,
  }
  file { '/etc/openvpn/ccd':
    ensure => directory,
    mode => 0755,
    owner => $user,
  }
  file { '/var/log/openvpn':
    ensure => directory,
    mode => 0755,
    owner => $user,
  }
  file { '/etc/openvpn/ccd/client':
    ensure => file,
    content => "iroute 192.168.20.0 255.255.255.0",
    mode => 0755,
    owner => $user,
  }

  service {'openvpn@server':
    require => Package['openvpn'],
    ensure => running,
    enable => true,
    subscribe => [
      File['/etc/openvpn/ccd/client'],
      File['/etc/openvpn/server.conf'],
    ]
  }

}
