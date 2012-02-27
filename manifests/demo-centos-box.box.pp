# Ensure that these packages are present
class base-packages {
  package{"curl":
    ensure => present,
  }
  package{"git":
    ensure => present,
  }
}

# You may want to include these if you need to poke around the box
# They're not essential to running the application
class niceties {
  package{"man":
    ensure => present,
  }
  package{"vim":
    ensure => present,
  }
}

class rvm-ruby {
  exec{"install-rvm":
    command => "/usr/bin/curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer | /bin/bash -s stable",
    creates => "/usr/local/rvm"
  }
  exec{"install-ruby":
    command => "/usr/local/rvm/bin/rvm install ruby-1.9.3-p125",
    creates => "/usr/local/rvm/rubies/ruby-1.9.3-p125",
  }
  exec{"set-default-ruby":
    command => "/usr/local/rvm/bin/rvm alias create default ruby-1.9.3-p125",
    creates => "/usr/local/rvm/rubies/default",
  }
  exec{"create-gemset":
    command => "/usr/local/rvm/bin/rvm gemset create demo",
    creates => "/usr/local/rvm/gems/ruby-1.9.3-p125@demo",
  }
  exec{"install-bundler":
    command => "/usr/local/rvm/bin/rvm gem install bundler",
    creates => "/usr/local/rvm/gems/ruby-1.9.3-p125/gems/bundler-1.0.22/",
  }
  Exec["install-rvm"] -> Exec["install-ruby"] -> Exec["set-default-ruby"]
  Exec["set-default-ruby"] -> Exec["create-gemset"] -> Exec["install-bundler"]
}

class rvm-users {
  user{"vagrant":
    ensure => present,
    groups => "rvm",
  }
}
# Chaining - make sure things go in a reasonable order
Class['base-packages'] -> Class['rvm-ruby']

include base-packages
#include niceties # Non-essentials
include rvm-ruby
include rvm-users
