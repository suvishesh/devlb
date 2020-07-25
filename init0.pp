#flow

Class['docker'] -> Class['checkmk']


class docker {
package { 'docker':
ensure => present,
}
service { 'docker':
ensure => running,
require => Package['docker'],
}
file { "/root/Dockerfile":

        owner => 'root',
        group => 'root',
        source => 'puppet:///modules/docker/Dockerfile',
    }

file { "/root/index.html":

        owner => 'root',
        group => 'root',
        source => 'puppet:///modules/docker/index.html',
    }

exec { 'rm':
command => '/bin/docker rm -f $(sudo docker ps -a -q)',
#before => Exec['build'],
#unless => '/bin/docker ps | grep website 1>/dev/null',
#notify => Exec['build'],
onlyif => '/bin/docker ps | grep website'
}

exec { 'build':
command => '/bin/docker build . -t website',
#require => Exec['rm'],
#onlyif => '/bin/docker ps | grep website'
}
exec { 'run':
command => '/bin/docker run -it -d -p 82:80 -d website',
require => Exec['build'],
}
}


class checkmk {
	
exec { 'epel-release':
command => '/bin/yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm',
unless => '/bin/yum list installed | grep epel-release 2>/dev/null',
}	
package { 'xinetd':
ensure => present,
}
service { 'xinetd':
ensure => running,
require => Package['xinetd'],
}
exec { 'cmkagent':
command => '/bin/yum install -y http://18.217.172.107/dockmon/check_mk/agents/check-mk-agent-1.5.0p24-1.noarch.rpm',
unless => '/bin/yum list installed | grep check-mk-agent 2>/dev/null'
}
}


