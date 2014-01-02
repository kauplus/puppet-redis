class redis {

  # This script implements a mix of the two following tutorials:
  # http://codingsteps.com/install-redis-2-6-on-ubuntu/
  # http://redis.io/topics/quickstart

  if $redis_installed == "true" {
    notice("Redis is already installed. Skipping this step.")
  }
  else {
    notice("Installing Redis.")

    #
    # 1) Download the source code, unpack and compile.
    #

    exec { 'get-redis-src':
      command => "/usr/bin/wget http://download.redis.io/releases/redis-2.8.3.tar.gz",
      cwd     => "/tmp"
    }

    exec { 'unpack-redis':
      command => "/bin/tar xzf redis-2.8.3.tar.gz",
      cwd     => "/tmp",
      require => Exec['get-redis-src']
    }

    exec { 'compile-redis':
      command => "/usr/bin/make",
      cwd     => "/tmp/redis-2.8.3",
      require => Exec['unpack-redis']
    }

    #
    # 2) Create Redis user and log files
    #

    user { 'redis-user':
      name    => 'redis',
      ensure  => 'present',
      require => Exec['compile-redis']
    }

    file { 'redis-lib-directory':
      path    => '/var/lib/redis',
      owner   => 'redis',
      ensure  => 'directory',
      require => User['redis-user']
    }

    file { 'redis-log-directory':
      path    => '/var/log/redis',
      owner   => 'redis',
      ensure  => 'directory',
      require => User['redis-user']
    }

    #
    # 3) Install files
    #

    file { 'redis-config-dir':
      ensure  => 'directory',
      path    => '/etc/redis',
      require => Exec['compile-redis']
    }

    file { 'redis-config-file':
      ensure  => present,
      path    => "/etc/redis/redis.conf",
      source  => 'puppet:///modules/redis/redis.conf',
      require => File['redis-config-dir']
    }

    exec { 'move binary files':
      command => "/bin/cp redis-cli redis-server redis-check-aof redis-check-dump /usr/local/bin/",
      cwd     => "/tmp/redis-2.8.3/src",
      require => Exec['compile-redis']
    }

    file { 'redis-init-script':
      ensure  => present,
      path    => "/etc/init.d/redis-server",
      source  => 'puppet:///modules/redis/redis-server',
      require => Exec['compile-redis']
    }

    exec { 'configure-init-script':
      command => "/bin/chmod +x /etc/init.d/redis-server",
      require => File['redis-init-script']
    }

    exec { 'enable-redis-server':
      command => '/usr/sbin/update-rc.d redis-server defaults',
      require => Exec['configure-init-script']
    }

    exec { 'start-redis-server':
      command => '/usr/sbin/service redis-server start',
      require => Exec['enable-redis-server']
    }

  }

  # ################################
  # Uninstall Redis
  # ################################

  # sudo rm -r /var/lib/redis /var/log/redis /etc/redis/redis.conf

  # sudo rm /usr/local/bin/redis-cli /usr/local/bin/redis-server /usr/local/bin/redis-check-aof /usr/local/bin/redis-check-dump

  # sudo update-rc.d -f redis-server remove
  # sudo rm /etc/init.d/redis-server

  # ################################
  # How to use the init.d scripts
  # ################################

  # sudo service redis-server start (stop) (restart)

}
