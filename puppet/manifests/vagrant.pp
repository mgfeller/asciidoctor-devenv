# install and configure git
include git

git::config { 'user.name':
  value   => 'Michael Gfeller',
  user    => 'vagrant',
  require => Class['git'],
}

git::config { 'user.email':
  value   => 'mgfeller@mgfeller.net',
  user    => 'vagrant',
  require => Class['git'],
}

git::config { 'core.autocrlf':
  value   => 'input',
  user    => 'vagrant',
  require => Class['git'],
}

git::config { 'core.editor':
  value   => 'vim',
  user    => 'vagrant',
  require => Class['git'],
}

# install unzip
package { 'unzip':
  require => Exec['apt-update'],
  ensure => installed,
}

# install ncftp - ftp client
package { 'ncftp':
  require => Exec['apt-update'],
  ensure => installed,
}

# install spf13-vim
exec { 'install spf13-vim':
    environment => ['HOME=/home/vagrant'],
    command => '/usr/bin/curl http://j.mp/spf13-vim3 -L -o - | sh',
    cwd => '/home/vagrant/',
    creates => '/home/vagrant/.spf13-vim-3',
    require => Package['git'],
}

exec { 'apt-update':                    
  command => '/usr/bin/apt-get update'  
}

# timezone 
file { '/etc/timezone':
    ensure => present,
    content => "Europe/Oslo\n",
}

exec { 'reconfigure-timezone':
        user => root,
        group => root,
        command => '/usr/sbin/dpkg-reconfigure --frontend noninteractive tzdata',
        require => [File['/etc/timezone'], Exec['apt-update']],
}

# needed for building native ruby gems
package { 'g++':
  require => Exec['apt-update'],
  ensure => installed,
}

# the base box already has ruby and rubygems installed
package { 'ruby-dev':
  require => Exec['apt-update'],
  ensure => installed,
}

# required for neocomplete
package { 'vim-nox':
  require => Exec['apt-update'],
  ensure => installed,
}

# required for nokigiri v 1.5.11
package { 'libxslt-dev':
  require => Exec['apt-update'],
  ensure => installed,
}

# required for nokigiri v 1.5.11
package { 'libxml2-dev':
  require => Exec['apt-update'],
  ensure => installed,
}

# required for nokigiri v 1.5.11
package { 'zlib1g-dev':
  require => Exec['apt-update'],
  ensure => installed,
}

# useful
package { 'libxml2-utils':
  require => Exec['apt-update'],
  ensure => installed,
}

package { 'bundler':
    ensure   => 'installed',
    provider => 'gem',
}

file { '/home/vagrant/.vimrc.local':
    ensure => 'present',
    owner  => vagrant,
    group  => vagrant,    
    mode => 664,    
    source => 'puppet:///modules/vim/.vimrc.local',
    require => Exec['install spf13-vim'],    
}

file { '/home/vagrant/.vim/syntax':
    owner  => vagrant,
    group  => vagrant,    
    mode => 755,
    ensure => 'directory',
    require => Exec['install spf13-vim'],
}

file { '/home/vagrant/.vim/syntax/asciidoc.vim':
    ensure => 'present',
    owner  => vagrant,
    group  => vagrant,
    mode => 664,    
    source => 'puppet:///modules/vim/asciidoc.vim',
    require => [File['/home/vagrant/.vim/syntax'], Exec['install spf13-vim'] ],
}

ssh_keygen { 'vagrant': }

# nginx installation and configuration
package { 'nginx':
  ensure => present,
  require => Exec['apt-update'],
}

file { '/home/vagrant/nginx':
    owner  => vagrant,
    group  => vagrant,    
    mode => 755,
    ensure => 'directory',
    require => Package['nginx'],
}

file { '/home/vagrant/nginx/default':
  owner  => vagrant,
  group  => vagrant,    
  mode => 664,
  ensure => 'present',
  source => 'puppet:///modules/nginx/default',
  require => File['/home/vagrant/nginx'],
}

file { '/etc/nginx/sites-enabled/default':
  ensure => 'link',
  target => '/home/vagrant/nginx/default',
  require => [File['/home/vagrant/nginx/default'], Package['nginx']],
  notify => Service['nginx'],
}

service { 'nginx':
  ensure => running,
  require => Package['nginx']
}

# bin folder
file { '/home/vagrant/bin/':
  owner  => vagrant,
  group  => vagrant,    
  mode => 755,
  ensure => 'directory',
}

# install java
# this installs openjdk-7-jdk on Trusty
include java

# install maven
file { '/home/vagrant/bin/maven-3.3.3':
  owner  => vagrant,
  group  => vagrant,    
  mode => 664,
  ensure => 'present',
  source => 'puppet:///modules/maven/maven-3.3.3/',
  recurse => true,
  require => File['/home/vagrant/bin/'],
}

# make mvn executable
file { '/home/vagrant/bin/maven-3.3.3/bin/mvn':
  ensure  => 'present',
  mode    => '0755',
  owner    => 'vagrant',
  require => File['/home/vagrant/bin/maven-3.3.3'],
}

# install jbake
file { '/home/vagrant/bin/jbake-2.4.0':
  owner  => vagrant,
  group  => vagrant,    
  mode => 664,
  ensure => 'present',
  source => 'puppet:///modules/jbake/jbake-2.4.0/',
  recurse => true,
  require => File['/home/vagrant/bin/'],
}

# make jbake executable
file { '/home/vagrant/bin/jbake-2.4.0/bin/jbake':
  ensure  => 'present',
  mode    => '0755',
  owner    => 'vagrant',
  require => File['/home/vagrant/bin/jbake-2.4.0'],
}

# shell configuration
file { '/home/vagrant/.profile':
  owner  => vagrant,
  group  => vagrant,    
  mode => 664,
  ensure => 'present',
  source => 'puppet:///modules/shell/.profile',
}
