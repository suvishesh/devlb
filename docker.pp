exec { 'docker':
command => '/bin/curl -fsSL https://get.docker.com/ | sh',
}
exec { 'start':
command => '/bin/systemctl start docker',
require => Exec['docker']
}
