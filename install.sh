#/bin/bash

# *************************************************************
# *                                                           *
# * Name: install.sh                                          *
# * Version: v0.0.1                                           *
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
echo "${APPS[@]}"
bat=(
qcmd-v0.4.2-darwin-x64
qcmd-v0.4.2-linux-x86
qcmd-v0.4.2-linux-x64
qcmd-v0.4.2-linux-arm64
qcmd-v0.4.2-linux-mips64le
qcmd-v0.4.2-windows-x86.exe
qcmd-v0.4.2-windows-x64.exe
)
echo $bat
function init() {
    echo -e "\tselect operation"
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

        exit 0
        #else
        #    echo "Wrong select, enter number."
        #fi
    done
}

function install() {
    echo -e "\tselect wihch app to install"
    select app in ${APPS[@]}; do
        select_items $app
        exit 0
        #else
        #    echo "Wrong select, enter number."
        #fi
    done
}

function select_items() {
    item=$1
    appv="$(eval echo $(eval echo "\$\{"$item"\[\@\]\}"))"
    echo -e "\tselect wihch version to install"
    select app in ${appv[@]}; do
        wget "$base_url/$app"
        exit 0
        #else
        #    echo "Wrong select, enter number."
        #fi
    done
}

init
