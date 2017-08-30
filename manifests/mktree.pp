# == Class: fsutil::mktree
#
# Create a tree of sub directories
define fsutil::mktree(
  # parameters are populated from External(hiera)/Defaults/Fail
  String $mode = '0755',
  String $umask = '0022',
  Any $tree = undef,
  String $parent_path = '/',
){

  $p_path = regsubst($parent_path, '\/+', '/', 'G' )

  if $tree =~ Hash and ! empty($tree) {
    $tree.each | $key, $value | {
      $new_parent_path = regsubst("${p_path}/${key}", '\/+', '/', 'G' )
      fsutil::mktree { "${p_path}/${key}":
        tree        => '/',
        parent_path => $new_parent_path,
      }
      fsutil::mktree { " ${p_path}/${value}":
        tree        => $value,
        parent_path => $new_parent_path,
      }
    }
  } elsif $tree =~ Array and ! empty($tree) {
    $tree.each | $value | {
      fsutil::mktree { "${p_path}/${value}":
        tree        => $value,
        parent_path => $p_path,
      }
    }
  } elsif ( $tree =~ String or $tree =~ Numeric )and ! empty($tree) {
    $new_path = regsubst("${p_path}/${tree}", '\/+', '/', 'G' )
    validate_absolute_path($new_path)
    fsutil::mkmount { $new_path:
      mode  => $mode,
      umask => $umask,
    }
  }


}
