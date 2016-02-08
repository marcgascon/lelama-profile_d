# TODO: add documentation in line with
# http://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class profile_d(
  $hash_script  = {}
) {

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

  validate_hash($hash_script)
  create_resources(profile_d::script, $hash_script)

}
