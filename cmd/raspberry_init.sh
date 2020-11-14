#/bin/bash

# *************************************************************
# *                                                           *
# * Name: Raspbeery Init                                      *
# * Version: 0.0.1                                            *
# * Function: Init raspberry environment                      *
# * Create Time: 2020-11-14                                   *
# * Modify Time:                                              *
# * Writen by PoplarYang (echohelloyang@gmail.com)            *
# *                                                           *
# *************************************************************


echo "Change apt source to ali"
sed -i 's@^deb http://raspbian.raspberrypi.org/raspbian/@deb http://mirrors.aliyun.com/raspbian/raspbian/@' /etc/apt/sources.list
apt-get update
