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

base_url=http://qinius.echosoul.cn
git_url=https://PoplarYang.github.io

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
format_disks.sh
git-completion.bash
)

CONFIGS=(
git_user_email.txt
)

MISC=(
git-completion
pipconf
s3cfg
dns
)

REPOS=(
Centos-6
Centos-7
Centos-8
ubuntu
)

function init() {
    echo -e "\tSelect operation type"
    select app in INSTALL CONFIG REPO FILES MISC; do
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
            MISC)
                misc
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

function select_items() {
    item=$1
    appv="$(eval echo $(eval echo "\$\{"$item"\[\@\]\}"))"
    echo -e "\tSelect wihch version to install"
    select app in ${appv[@]}; do
        wget "$base_url/$app"
        exit 0
    done
}


#TODO: such as s3cfg, pip.conf, ansible.cfg,
function config() {
    echo -e "\tSelect wihch config to install or download"
    select f in ${CONFIGS[@]}; do
        if echo $f | grep -q "\.txt$"; then
            curl -sSL "$git_url/configs/$f"
        else
            wget "$git_url/configs/$f"
        fi
        exit 0
    done
}


#TODO: such as centos6/7/8, ubuntu16/18/20, debian9/10, Neokylin v7, Kylin v10,
function repo() {
    select f in ${REPOS[@]}; do
        if [[ $f == Centos* ]]; then
            version=$(echo $f | awk -F '-' '{print $2}')
            wget https://mirrors.aliyun.com/repo/Centos-${version}.repo
            wget https://mirrors.aliyun.com/repo/epel-${version}.repo
            wget https://openresty.org/package/centos/openresty.repo
            exit 0
        elif [[ $f == "ubuntu" ]]; then
            # add base repo
            cat > /etc/apt/sources.list.d/base.list << EOF
deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -sc) main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -sc)-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -sc)-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -sc)-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -sc)-backports main restricted universe multiverse
EOF
            # add ansible repo
            add-apt-repository ppa:ansible/ansible

            # add openresty repo
            # 安装导入 GPG 公钥时所需的几个依赖包（整个安装过程完成后可以随时删除它们）：
            sudo apt-get -y install --no-install-recommends wget gnupg ca-certificates

            # 导入我们的 GPG 密钥：
            wget -O - https://openresty.org/package/pubkey.gpg | sudo apt-key add -

            # 添加我们官方 APT 仓库：
            echo "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main" \
                | sudo tee /etc/apt/sources.list.d/openresty.list
	    exit 0
        fi
    done
}


function files() {
    echo -e "\tSelect wihch file to download"
    select f in ${FILES[@]}; do
        wget "$git_url/files/$f"
        exit 0
    done
}


function misc() {
    echo -e "\tSelect wihch to install"
    select cmd in ${MISC[@]}; do
        eval $cmd
    done
}

function git-completion() {
    wget --timeout=10 https://raw.github.com/git/git/master/contrib/completion/git-completion.bash -O ~/.git-completion.bash
    cat << EOF
Please add bellow command to your cuurent $HOME/.bashrc or $HOME/.zshrc

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi
EOF
}

function pipconf() {
    mkdir $HOME/.pip &> /dev/null
    cat > $HOME/.pip/pip.conf << EOF
[global]
index-url=https://pypi.douban.com/simple/
extra-index-url=http://mirrors.aliyun.com/pypi/simple/
        https://pypi.tuna.tsinghua.edu.cn/simple/
        http://pypi.mirrors.ustc.edu.cn/simple/
timeout=20
[install]
trusted-host=pypi.douban.com
        mirrors.aliyun.com
        pypi.tuna.tsinghua.edu.cn
        pypi.mirrors.ustc.edu.cn
[freeze]
timeout = 10
EOF
    if [ $? -eq 0 ]; then
        echo "gen $HOME/.pip/pip.conf ok"
    else
        echo "gen $HOME/.pip/pip.conf failed"
    fi
}

function s3cfg() {
    cat << EOF
# $HOME/.s3cfg
[default]
access_key = <access_key>
secret_key = <secret_key>
bucket_location = <region>
host_base = <endpoint>
host_bucket = <endpoint>
use_https = False

# or
s3cmd --configure \\
    --access_key=<access_key> \\
    --secret_key=<secret_key> \\
    --region=<region> \\
    --host=<endpoint> \\
    --host-bucket=<endpoint> \\
    --no-ssl
EOF
}

function dns() {
    cat << EOF
nameserver 223.5.5.5
nameserver 223.6.6.6
EOF
}

init
