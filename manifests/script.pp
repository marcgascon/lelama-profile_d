# profile_d/manifest/script.pp
define profile_d::script (
  $ensure       = 'present',
  $content      = '',
  $content_file = '',
  $source       = '',
  $shell        = '/bin/sh',
  $user         = undef
) {

  include profile_d

  if ($content == '') and ($content_file == '') and ($source == '') {
    fail('You must pass in one of the following parameters $content, $content_file, $source on definition')
  }

  if (($content != '' and ($content_file != '' or $source != '')) or ($source != '' and $content_file != '')) {
    fail('Only one of the following $content, $content_file, $source parameters can be set on definition')
  }

  if (($source != '' and $user != undef)) {
    fail('It is not possible to use $source in combination with $user')
  }

  if ($content != '') {
    $content_value = inline_template("<%= scope.function_template(['profile_d/header.erb']) -%>${content}")
  }
  elsif ($content_file != '') {
    $content_value = template($content_file)
  }
  else {
    $content_value = undef
  }

  if ($source != '') {
    $source_value = $source
  }
  else {
    $source_value = undef
  }

  if ($user != undef and $user != 'root') {
    $home_dir = '/home'
  } else {
    $home_dir = ''
  }

  if ($user != undef) {
    file { "${home_dir}/${user}":
      ensure  => directory,
    }

    file { "${home_dir}/${user}/.profile.d":
      ensure  => directory,
      require => File["${home_dir}/${user}"]
    }

    file { "${home_dir}/${user}/.profile.d/${name}":
      ensure  => $ensure,
      content => $content_value,
      owner   => $user,
      mode    => '0644',
      require => File["${home_dir}/${user}/.profile.d"]
    }
  }
  else {
    file { "/etc/profile.d/${name}":
      ensure  => $ensure,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => $content_value,
      source  => $source_value,
      require => File['/etc/profile.d'],
    }
  }

}
