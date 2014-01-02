Redis module for Puppet
=======================

How to use
-----------------------

1. In your project directory, run:

        git submodule add https://github.com/kauplus/puppet-redis.git puppet/modules/redis

2. In your manifest file, include:

        class { redis: }

3. Provision your machine.


4. Reboot your machine OR manually start Redis with `sudo service redis-server start`.

5. Check that it worked.

        # Check version.
        redis-server --version

        # Check that it's running.
        sudo service redis-server status

Redis version
-----------------------
This version of the module will install Redis 2.8.3.

See available Redis versions here: [http://download.redis.io/releases/](http://download.redis.io/releases/)
