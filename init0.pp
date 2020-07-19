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
before => Exec['build'],
}
exec { 'build':
command => '/bin/docker build . -t website',
}
exec { 'run':
command => '/bin/docker run -it -d -p 82:80 -d website',
require => Exec['build'],
}
}

class nrpe {
	
exec { 'epel-release':
command => '/bin/yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm',
unless => '/bin/yum list installed | grep epel-release 2>/dev/null',
}

package { 'nrpe':
ensure => present,
}
service { 'nrpe':
ensure => running,
require => Package['nrpe'],
}

package { 'nagios-plugins-all':
ensure => present,
}

}
