name             'wp'
maintainer       'Amy Marrich'
maintainer_email 'amy.marrich@rackspace.com'
license          'All rights reserved'
description      'Installs/Configures wp'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.4'

depends "apt"
depends "apache2"
depends "mysql"
depends "php"
depends "database"
depends "mysql2_chef_gem"
depends "wordpress"
depends "poise"
depends "rackspace_lbaas"
depends 'mysql-multi', '~> 2.1.7'
