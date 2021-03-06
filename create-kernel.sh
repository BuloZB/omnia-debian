#!/bin/bash
#
# by Tomas Hlavacek (tmshlvck@gmail.com)
#
# prerequisities - Debian packages:
# git
# gcc-arm-linux-gnueabihf
# devscripts
# kernel-package
#

KERNELREPO="https://github.com/tmshlvck/omnia-linux.git"
KERNELBRANCH="omnia"


export ARCH=arm
export CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf-

if [ -d linux ]; then
  cd linux
  git checkout $KERNELBRANCH
  git pull origin $KERNELBRANCH
  make distclean
else
  git clone $KERNELREPO linux
  cd linux
  git checkout $KERNELBRANCH
fi

make omnia_defconfig

export DEB_HOST_ARCH=armhf
export CONCURRENCY_LEVEL=`grep -m1 cpu\ cores /proc/cpuinfo | cut -d : -f 2`

make-kpkg --rootcmd fakeroot --arch arm --cross-compile arm-linux-gnueabihf- --revision=1.0 kernel_image kernel_headers
