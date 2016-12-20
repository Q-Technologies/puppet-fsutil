# == Class: qtlib::mkmount
#
# Module to abstract the dumping of databases to flat files
#
define qtlib::mkmount(
  # Class parameters are populated from External(hiera)/Defaults/Fail
  String $mode = '0755',
  String $umask = '0022',
){
  include stdlib

  validate_absolute_path($name)

  exec { "mkdir_p-${name}":
    command => "mkdir -p ${name}",
    umask   => $umask,
    unless  => "test -d ${name}",
    path    => '/bin:/usr/bin',
  }

  file { $name:
    ensure => directory,
    mode   => $mode,
  }
}
