# puppet-fsutil
Some helpful filesystem functions to minimise code repetition.

#### Table of Contents

1. [Description](#description)
1. [Instructions](#instructions)
1. [Reference](#reference)
1. [Development](#development)
1. [Issues](#issues)

## Description

This **fsutil** module provides a higher level interface to common filesystem actions.  It aims to reduce the code in your profiles.  Most
of the action can be driven through Hiera.  Some assumptions are made:
  * only performs the mount action (and inserts entry into fstab)
  * manages the mount point directory

## Instructions
Call the class from your code, e.g. 
```
class { 'fsutil': }
```
 or 
```
include 'fsutil'
```

Use Hiera to drive the configuration.  E.g.:
```
fsutil::nfs_mounts:
  /code: mac:/Users/matt/code
  /downloads: 
    device: mac:/Users/matt/Downloads
    options: ro,hard,intr

```
## Reference

### Data Structures

#### nfs_mounts
To mount a number of NFS mounts, define a Hash in Hiera with all the mount points as the keys.  The Hash values can either be a String of the remote share to mount or another Hash with the following additional options:
  * device - remote share to mount
  * options (default = 'defaults') - the mount options to use,
  * mode (default = 0755) - the mode of the mount point
  * umask (default = 0022) - the umask to use when any parent directories get created
Any parent directories needed for the mount point (and the mount point itself) will be created and managed by Puppet

### Defined Resources

#### fsutil::mount_nfs
Mounts a remote NFS share on a local mount point.  Options:
  * device - remote share to mount
  * options (default = 'defaults') - the mount options to use,
  * mode (default = 0755) - the mode of the mount point
  * umask (default = 0022) - the umask to use when any parent directories get created
Any parent directories needed for the mount point (and the mount point itself) will be created and managed by Puppet
Example:
```
fsutil::mount_nfs { '/downloads':
  device  => 'mac:/Users/matt/Downloads',
  options => 'ro,hard,intr',
}

```

#### fsutil::mkmount
Creates a full path of directories and sets the mode for a mount point.  Options:
  * mode (default = 0755) - the mode of the mount point
  * umask (default = 0022) - the umask to use when any parent directories get created
Example:
```
fsutil::mkmount {  '/temp':
  mode    => '0777',
  umask   => '0222',
}
```

#### fsutil::mkdir_p
Creates a full path of directories.  Options:
  * umask (default = 0022) - the umask to use when any parent directories get created
Example:
```
fsutil::mkdir_p { '/secrets': 
  umask   => '0200',
}
```


#### fsutil::mktree
Creates a full tree of directories.  It expands a Hash or Array (or combination) and uses the fsutil::mkmount resource to create the directory. Options:
  * umask (default = 0022) - the umask to use when any parent directories get created
  * mode (default = 0755) - the mode of the directory
Example:
```
fsutil::mktree { '/secrets': 
  umask   => '0200',
  umask   => '0755',
  tree => { '/repo' => ['baseline', 'packages', {'os' => [{'Centos' => [6, 7]}]}]}],
}
```

This will create the following directories:

```
/repo
/repo/baseline
/repo/packages
/repo/os
/repo/os/Centos
/repo/os/Centos/6
/repo/os/Centos/7
```

Alternatively, you can specify hiera data and include the class:
```
fsutil::tree:
  repo:
    - baseline
    - packages
    - os:
      - Centos:
        - 6
        - 7
```



## Development
If you would like to contribute to or comment on this module, please do so at it's Github repository.  Thanks.


## Issues
This module is using hiera data that is embedded in the module rather than using a params class.  This may not play nicely with other modules using the same technique unless you are using hiera 3.0.6 and above (PE 2015.3.2+).
