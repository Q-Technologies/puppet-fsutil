# == Class: fsutil
#
# Module to store common functions and defines
#
class fsutil(
  # Class parameters are populated from External(hiera)/Defaults/Fail
  Data $nfs_mounts = {},
  Data $tree = {},
){

  if $nfs_mounts =~ Hash and ! empty($nfs_mounts) {
    fsutil::mount_nfs_hash { 'fsutil_nfs_mounts':
      nfs_mounts => $nfs_mounts,
    }
  }
  if ! empty($tree) {
    fsutil::mktree { 'tree':
      tree => $tree,
    }
  }
}
