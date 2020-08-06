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
git_url=http://PoplarYang.github.io/files

APPS=(
bat
bmon
fd
qcmd
speedtest
speedtest_go
upto
)

bat=(
bat-v0.15.4-x86_64-apple-darwin
bat-v0.15.4-x86_64-unknown-linux-gnu
bat-v0.15.4-arm-unknown-linux-gnueabihf
bat-v0.15.4-aarch64-unknown-linux-gnu
)

bmon=(
bmon.v4.0.darwin-amd64
bmon.v3.6.linux-amd64
bmon.v4.0.linux-mips64el
)

fd=(
fd-v8.1.1-x86_64-apple-darwin
fd-v8.1.1-x86_64-unknown-linux-gnu
fd-v8.1.1-arm-unknown-linux-gnueabihf
)

qcmd=(
qcmd.v0.4.2.darwin-amd64
qcmd.v0.4.2.linux-amd64
qcmd.v0.4.2.linux-arm64
qcmd.v0.4.2.linux-mips64el
qcmd.v0.4.2.windows-amd64.exe
)

speedtest=(
speedtest-mac-amd64-2.0.0-a-2-g18a889d
speedtest-linux-amd64-2.0.0-a-2-g18a889d
speedtest-linux-arm-2.0.0-a-2-g18a889d
)

speedtest_go=(
speedtest-go.v1.0.3.darwin-amd64
speedtest-go.v1.0.3.linux-amd64
speedtest-go.v1.0.3.linux-arm64
speedtest-go.v1.0.3.linux-mips64el
speedtest-go.v1.0.3.windows-amd64.exe
)

upto=(
upto.v0.0.1.darwin-amd64
upto.v0.0.1.linux-amd64
upto.v0.0.1.linux-arm64
upto.v0.0.1.linux-mips64el
upto.v0.0.1.windows-amd64.exe
)

FILES=(
Makefile
)

function init() {
    echo -e "\tSelect operation type"
    select app in INSTALL CONFIG REPO FILES; do
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
	    FILES)
		files
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

function files() {
    echo -e "\tSelect wihch file to download"
    select f in ${FILES[@]}; do
        wget "$git_url/files/$f"
	exit 0
    done
}

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
