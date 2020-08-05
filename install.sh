#!/bin/bash

# *************************************************************
# *                                                           *
# * Name: install.sh                                          *
# * Version: v0.0.2                                           *
# * Function: quick install app base on arch and os           * 
# * Create Time: 2020-08-05                                   *
# * Modify Time: 2020-08-05                                   *
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

base_url=http://qinius.echosoul.cn

APPS=(
bat
qcmd
bmon
)

bat=(
qcmd.v0.4.2.darwin-amd64
qcmd.v0.4.2.linux-386
qcmd.v0.4.2.linux-amd64
qcmd.v0.4.2.linux-arm64
qcmd.v0.4.2.linux-mips64el
qcmd.v0.4.2.windows-386.exe
qcmd.v0.4.2.windows-amd64.exe
)

function init() {
    echo -e "\tSelect operation type"
    select app in INSTALL CONFIG REPO; do
        case $app in
	    INSTALL)
		install
		;;
	    CONFIG)
	        config
		;;
	    REPO)
	        repo
		;;
	    *)
                echo "Wrong select, enter number."
		;;
	esac
    done
}

function install() {
    echo -e "\tSelect wihch app to install"
    select app in ${APPS[@]}; do
        select_items $app
    done
}

#TODO: such as s3cfg, pip.conf, ansible.cfg,
#function config() {
#}

#TODO: such as centos6/7/8, ubuntu16/18/20, debian9/10, Neokylin v7, Kylin v10,
#function repo() {
#}

function select_items() {
    item=$1
    appv="$(eval echo $(eval echo "\$\{"$item"\[\@\]\}"))"
    echo -e "\tSelect wihch version to install"
    select app in ${appv[@]}; do
        wget "$base_url/$app"
        exit 0
    done
}

init
