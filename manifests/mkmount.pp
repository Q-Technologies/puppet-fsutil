# == Class: util::mkmount
#
# Create a mount point and all parent directories if they don't exist
define fsutil::mkmount(
  # parameters are populated from External(hiera)/Defaults/Fail
  String $mode = '0755',
  String $umask = '0022',
){
  fsutil::mkdir_p { $name:
    umask   => $umask,
  }
  file { $name:
    ensure => directory,
    mode   => $mode,
  }
}
