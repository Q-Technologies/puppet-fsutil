# == Class: fsutil::mount_nfs
#
# Mount an NFS share on a directory - make sure the directory exists
#
#
define fsutil::mount_nfs(
  # parameters are populated from External(hiera)/Defaults/Fail
  String $device, # must be set - no defaults
  String $options = $fsutil::nfs_options,
  String $mode = '0755',
  String $umask = '0022',
){
    fsutil::mkmount { $name:
      mode   => $mode,
      umask  => $umask,
      before => Mount[$name],
    }
    mount { $name:
      ensure  => mounted,
      fstype  => nfs,
      options => $options,
      device  => $device,
  }
}
