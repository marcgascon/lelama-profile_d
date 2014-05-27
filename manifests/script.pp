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

  if ($user != undef) {
    $content_value_safe = regsubst($content_value, "(')", "'\\\\''",'G') 
    if ($ensure == present) {
      exec { "Adding ${name} for ${user}":
        path    => "/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin",
        command => "mkdir -p ~${user}/.profile.d && echo '${content_value_safe}' > ~${user}/.profile.d/${name}",
        unless  => "test -e ~${user}/.profile.d/ && cat ~${user}/.profile.d/${name} | grep '${content_value_safe}'",
        user    => $user,
      }
    }
    else {
      exec { "Removing ${name} for ${user}":
        path    => "/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin",
        command => "find ~${user}/.profile.d/ -name ${name} -exec rm -f {} \\;",
        onlyif  => "test -e ~${user}/.profile.d/${name}",
        user    => $user,
      }
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
