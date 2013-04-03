class profile_d {

  file {'/etc/profile.d':
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }
  
  profile_d::script { 'user_profile_d.sh':
    content => '
if [ -d "$HOME/.profile.d" ]; then 
    for file in $HOME/.profile.d/*; do 
        . $file 
    done 
fi',
  }
}
