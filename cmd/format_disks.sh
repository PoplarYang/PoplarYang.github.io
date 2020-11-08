#/bin/bash

# *************************************************************
# *                                                           *
# * Name: format_disk.sh                                      *
# * Version: v0.0.1                                           *
# * Function: format disk on linux                            *
# * Create Time: 2017-10-10                                   *
# * Modify Time: 2020-08-19                                   *
# * Writen by PoplarYang (echohelloyang@gmail.com)            *
# *                                                           *
# *************************************************************

function usage() {
    cat << EOF
format disk Usages:
    format all disks that is not mounted
        bash $0
    format disks from command line input
        bash $0 /dev/sdb /dev/sdc ...
EOF
}

if [ $# -eq 1 ]; then
    if [ $1 == "--help" ] || [ $1 == "-h" ]; then
        usage
        exit
    fi
fi

FSTYPE=xfs
MOUNT_DIR_PREFIX='/disk'

# find all disks in this server
DiskDev=$(fdisk -l 2> /dev/null | egrep "^Disk /dev/vd|^Disk /dev/sd| /dev/vd|  /dev/sd" | \
          cut -d" " -f 2 | grep -o "/dev/..." | sort)

# find all disks that has been mounted
MOUNTED_DISKS=$(df -h | grep "^/" | cut -d' ' -f1)

# get disks from command line, multiple disks should be separated by space
if [ $# -gt 0 ]; then
    DiskDev=$@
fi

DiskFormat()
{
    NUMBER=1
    for dev in $DiskDev;do
        if [ -e $dev ]; then
            if echo $MOUNTED_DISKS | grep -q $dev > /dev/null; then
                echo -e "\e[31mDisk $dev has been mounted...\e[0m"
            else
                echo "Disk $dev is being formated..."
                #time parted -s $dev 'mklabel gpt unit GB mkpart primary 0 -1'
                yes | parted $dev mklabel gpt &> /dev/null && parted $dev mkpart primary 2048s 100%
                sleep 3
                if [ $FSTYPE == "ext4" ]; then
                    time mkfs.ext4 -L ${dev} -m 0.01 ${dev} &> /dev/null && \
                        echo -e "\e[32mformat ${dev} OK.\e[0m" || echo -e "\e[31mformat ${dev} failed.\e[0m"
                    mkdir ${MOUNT_DIR_PREFIX}${NUMBER} &> /dev/null
                    echo "LABEL=${dev} ${MOUNT_DIR_PREFIX}${NUMBER}  ext4  defaults,noatime    0  2"  >> /etc/fstab
                elif [ $FSTYPE == "xfs" ]; then
                    time mkfs.xfs -f ${dev} &> /dev/null && \
                        echo -e "\e[32mformat ${dev} OK.\e[0m" || echo -e "\e[31mformat ${dev} failed.\e[0m"
		            xfs_admin -L ${dev} ${dev}
                    mkdir ${MOUNT_DIR_PREFIX}${NUMBER} &> /dev/null
                    echo "LABEL=${dev} ${MOUNT_DIR_PREFIX}${NUMBER}  xfs  defaults,noatime    0  2"  >> /etc/fstab
                fi
                NUMBER=$(( $NUMBER + 1 ))
            fi
        else
            echo -e "\e[31m$dev dose not exists.\e[0m"
        fi
    done
}

DiskFormat
