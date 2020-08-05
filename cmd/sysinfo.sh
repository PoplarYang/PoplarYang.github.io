#/bin/bash

# *************************************************************
# *                                                           *
# * Name: system environment info                             *
# * Version: 0.0.2                                            *
# * Function: get system environment info                     *
# * Create Time: 2020-08-03                                   *
# * Modify Time: 2020-05-05                                   *
# * Writen by PoplarYang (echohelloyang@gmail.com)            *
# *                                                           *
# *************************************************************

function get_data() {
    OS=$(uname)
    case $OS in
        HP-UX)
            OS=HP-UX
            VERSION=""
	        CPU=$(lscpu | sed 's/型号名称：/Model name:/g' | egrep "Architecture|^CPU\(s\)|Model name" | sed 's/\s\+//g')
            TOTAL_MEM=$(cat /proc/meminfo | grep MemTotal | awk '{print $2/1024/1024"G"}')
	    ;;
        AIX)
            OS=AIX
            VERSION=""
	        CPU=$(lscpu | sed 's/型号名称：/Model name:/g' | egrep "Architecture|^CPU\(s\)|Model name" | sed 's/\s\+//g')
            TOTAL_MEM=$(cat /proc/meminfo | grep MemTotal | awk '{print $2/1024/1024"G"}')
	    ;;
        SunOS)
            OS=SunOS
            VERSION=""
	        CPU=$(lscpu | sed 's/型号名称：/Model name:/g' | egrep "Architecture|^CPU\(s\)|Model name" | sed 's/\s\+//g')
            TOTAL_MEM=$(cat /proc/meminfo | grep MemTotal | awk '{print $2/1024/1024"G"}')
	    ;;
        Darwin)
            OS=Darwin
            VERSION=""
	        model=$(sysctl machdep.cpu | grep machdep.cpu.brand_string | sed 's/machdep.cpu.brand_string/Model name/')
	        cpus=$(sysctl machdep.cpu | grep machdep.cpu.thread_count | sed 's/machdep.cpu.thread_count/CPU\(s\)/')
	        arch="Architecture: $(uname -m)"
	        CPU="$model\n$cpus\n$arch"
            TOTAL_MEM=$(top -l 1 | head -n 10 | grep PhysMem | awk '{print $2}')
	    ;;
        Linux)
            if [ -s /etc/oracle-release ]; then
                OS=Oracle
                VERSION=""
            elif [ -s /etc/SuSE-release ]; then
                OS=SuSE
                VERSION=""
            elif [ -f /etc/redhat-release ]; then
                OS=CentOS
                VERSION=$(awk -F" " '{print $4}' /etc/redhat-release)
            elif [ -r /etc/os-release ]; then
                grep 'NAME="Ubuntu' /etc/os-release > /dev/null 2>&1
                if [ $? == 0 ]; then
                    OS=Ubuntu
                    VERSION=$(head -n 1 /etc/issue | awk -F " " '{print $2}')
                fi
            else
                OS="Unknown Linux"
                VERSION="Unknown OS"
            fi
	        CPU=$(lscpu | sed 's/型号名称：/Model name:/g' | egrep "Architecture|^CPU\(s\)|Model name" | sed 's/\s\+//g')
            TOTAL_MEM=$(cat /proc/meminfo | grep MemTotal | awk '{print $2/1024/1024"G"}')
	    ;;
        *)
            OS="Unknown UNIX/Linux"
            VERSION="Unknown OS" ;;
    esac
    echo -e "Operation System: $OS $VERSION"
    KERNEL=$(uname -r)
    echo -e "$CPU"
    echo "Kernel Version: $KERNEL"
    echo "Memory Total: $TOTAL_MEM"
}

function format_data() {
    get_data | sed 's/\s\+//g'
}

format_data | column -s ":" -t
