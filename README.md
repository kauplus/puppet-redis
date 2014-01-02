Redis module for Puppet
=======================

How to use
-----------------------

1. In your modules directory (eg, /path/to/project/puppet/modules/), run:

        git submodule add https://github.com/kauplus/puppet-redis.git redis

2. In your manifest file, include:

        class { redis: }

3. Provision your machine.

Redis version
-----------------------
This version of the module will install Redis 2.8.3.

See available Redis versions here: [http://download.redis.io/releases/](http://download.redis.io/releases/)
