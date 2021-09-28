#!/usr/bin/env bash

echo "Where to install concurrent Openstack Swift upload scripts (default ${HOME}/bin)? "
read LOCATION
if [[ -z $LOCATION ]]; then
    LOCATION="${HOME}/bin"
    if [[ ! -d $HOME/bin ]]; then
        mkdir $HOME/bin
    fi
fi

echo "Begin installation? (y/n) "
read ans
if [[ ! $ans =~ "y" ]]; then
    exit
fi

install() {
    cp concurrent_rclone_copy.sh $LOCATION/concurrent_rclone_copy \
        && chmod u+x $LOCATION/concurrent_rclone_copy
    cp concurrent_rclone_rcat.sh $LOCATION/concurrent_rclone_rcat \
        && chmod u+x $LOCATION/concurrent_rclone_rcat
}

install && echo "Done installing concurrent Openstack Swift upload scripts"
