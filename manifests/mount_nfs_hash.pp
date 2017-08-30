# == Class: fsutil::mount_nfs_hash
#
# Mount an NFS share on a directory - make sure the directory exists
# Pass the mounts as a hash
#
define fsutil::mount_nfs_hash(
  # parameters are populated from External(hiera)/Defaults/Fail
  Data $nfs_mounts = {},
){
  if $nfs_mounts =~ Hash {
    $nfs_mounts.each | $mountpt, $params | {
      if $params =~ Hash {
        $device = $params['device']
        if empty( $device ) {
          fail( 'The device passed to fsutil::mount_nfs_hash for $mountpt must be set')
        }
        $new_params = $params
      } elsif $params =~ String {
        $device = $params
        $new_params = { device => $device }
      } else {
        fail( 'the parameters passed to fsutil::mount_nfs_hash needs to be a Hash or a String')
      }
      create_resources( fsutil::mount_nfs, { $mountpt => $new_params } )
    }
  } else {
    fail( 'fsutil::mount_nfs_hash expects a Hash of mount points and parameters to be passed to it')
  }
}
