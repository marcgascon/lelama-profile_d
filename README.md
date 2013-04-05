puppet-profile_d
=============

Puppet module to create scripts in /etc/profile.d or $HOME/.profile.d.

Depencendies:

    'puppetlabs/stdlib', '>=3.2.0'
    
Basic usage
-------------------------
Create a simple script that sets one variable

    profile_d::script { 'name-of-script.sh':
      ensure  => present,
      content => 'export VARIABLE=value',
    }
 
Create a multi-line script using a template

    profile_d::script { 'name-of-script.sh':
      ensure       => present,
      content_file => "${module_name}/script-template.sh.erb",
    }


Create a script using a file source

    profile_d::script { 'name-of-script.sh':
      ensure => present,
      source => "puppet:///modules/${module_name}/script.sh",
    }

Create a script to change the default shell (/bin/sh) :

    profile_d::script { 'name-of-script.sh':
	  ensure  => present,
      content => 'export VARIABLE=value',
      shell   => '/bin/bash',
    }
   
Create a script that sets one variable for the root user :

    profile_d::script { 'name-of-script.sh':
      ensure  => present,
      content => 'export VARIABLE=value',
      user    => 'root',
    }
