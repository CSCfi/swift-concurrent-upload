#!/usr/bin/env bash

# Script expects a sourced Openstack project (openrc) file and configured
# rclone remote for Swift

# Script expects rclone remote for swift object store in $RCLONE_DESTINATION

# Can configure maximum simultaneous uploads in $MAX_PROCESSES environment
# variable – recommended is amount of threads

# $1 is the location to be copied, $2 is the destination container


# Get files that are larger than 5GiB
FILES_LARGE=$(find $1 -type f -size +5368709120c)

# Configure maximum simultaneous uploads
if [[ -z $MAX_PROCESSES ]]; then
    MAX_PROCESSES=4
fi

# Upload large files – the speed benefit varies, but seems consistently faster
# in testing
for file in $FILES_LARGE; do
    concurrent_rclone_rcat $file $2 \
    && echo "Successfully uploaded files >5GiB"
done

# Upload the rest
rclone --transfers=$MAX_PROCESSES --swift-no-chunk copy --ignore-existing --progress $1 $RCLONE_DESTINATION:$2/$1

echo "DONE uploading ${1}"
