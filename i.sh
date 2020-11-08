#!/bin/bash

# *************************************************************
# *                                                           *
# * Name: i.sh                                                *
# * Version: v0.0.6                                           *
# * Function: quick install app base on arch and os           *
# * Create Time: 2020-08-05                                   *
# * Modify Time: 2020-09-30                                   *
# * Writen by PoplarYang (echohelloyang@gmail.com)            *
# *                                                           *
# *************************************************************

#function support() {
#    echo "Select Number:"
#    for config in $(ls $CONFIG_DIR); do
#        echo -e "\t$config"
#    done
#}
#
#support

base_url=http://qjhcjqfnk.hd-bkt.clouddn.com

BINS=(
s3browser-cli.darwin
)

function bin() {
    echo -e "\tSelect wihch plantform s3browser download"
    select f in ${BINS[@]}; do
        wget "$base_url/bin/$f"
    done
}

bin
