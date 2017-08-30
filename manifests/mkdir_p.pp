# == Class: fsutil::mkdir_p
#
# Create a directory and all parent directories if they don't exist
define fsutil::mkdir_p(
  # parameters are populated from External(hiera)/Defaults/Fail
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

}
