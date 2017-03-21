#A Chassis extension to help you setup a local version of Photon for development
class photon (
  $path = '/vagrant/extensions/photon'
) {
  package { 'php-pear':
    ensure  => latest,
    require => Package['php5-dev']
  }
  package { 'php5-dev':
    ensure => latest,
  }
  package { 'libgraphicsmagick1-dev':
    ensure => latest,
  }
  package { 'graphicsmagick':
    ensure => latest
  }
  #PHP7
  #command => "pecl install channel://pecl.php.net/gmagick-2.0.4RC1"
  exec { 'gmagick install':
    #PHP5
    command => 'pecl install gmagick-1.1.7RC3',
    path    => ['/bin', '/usr/bin'],
    require => Package[ 'php5-cli', 'php5-dev', 'php-pear', 'php5-fpm', 'php5-imagick' ],
    unless  => 'pecl info gmagick',
    notify  => Service['php5-fpm'],
  }

  file { '/etc/php5/fpm/conf.d/gmagick.ini':
    content => template('photon/gmagick.ini.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['php5-fpm'],
    require => Package['php5-fpm']
  }
}
