package { 'docker':
ensure => present,
}
service { 'docker':
ensure => running,
require => Package['docker'],
}
exec { 'rm':
command => '/bin/docker rm -f $(sudo docker ps -a -q)',
before => Exec['build'],
}
exec { 'build':
command => '/bin/docker build . -t website',
}
exec { 'run':
command => '/bin/docker run -it -d -p 82:80 -d website',
require => Exec['build'],
}
