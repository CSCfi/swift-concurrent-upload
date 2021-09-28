# Examples for implementing concurrent file uploads for CSC Allas
Repo contains a concurrent upload script using mostly dependencies already
present on any computer that has CSC Allas CLI utilities installed.

It introduces one new dependency, `jq`, for parsing json input in a more
convenient manner.

## concurrent_rclone_copy.sh
`concurrent_rclone_copy.sh` is a script that splits off files by file size,
to be uploaded concurrently for better performance against object storage.
It splits files up by the following three rules, in the following order:
1. Files over 5GiB will be uploaded using `concurrent_rclone_rcat.sh`. These
   files will be uploaded in segments, using a separate process for each 
   segment.
2. Rest of the files will be uploaded with normal `rclone sync`. The script
   achieves this by uploading these files last, ignoring all files that are
   already present in the object storage

By treating each file with the fastest respective solution, the best overall
upload speed should be reached.

This is the overall tool that you probably want to use.

## concurrent_rclone_rcat.sh
`concurrent_rclone_rcat.sh` is a script for uploading a large file in segments
concurrently, so that the underlying object storage can reach higher speeds.
Concurrent writing of segments is beneficial so that the object storage
backend can write to multiple disks at once, due to it being a JBOD in the
background.

This script works extremely well for uploading a single large file.

# Dependencies
* rclone
* python-openstackclient
* curl
* jq
* md5sum (for concurrent_swift_md5sum)

# Usage
```
source [Openstack openrc project file]
export RCLONE_DESTINATION=[rclone swift remote]
export MAX_PROCESSES=[machine hw thread count]  # OPTIONAL
$ ./concurrent_rclone_copy [source folder] [destination container]
```
