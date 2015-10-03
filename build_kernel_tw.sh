#!/bin/sh
export KERNELDIR=`readlink -f .`
export PARENT_DIR=`readlink -f ..`
export CROSS_COMPILE=/usr/bin/aarch64-linux-gnu-
# export CROSS_COMPILE=/home/googy/Downloads/linaro49/bin/aarch64-linux-gnu-
# export KCONFIG_NOTIMESTAMP=true
# export USE_SEC_FIPS_MODE=true

VER="\"-Googy-Max-S6-v$1\""
cp -f /home/googy/Kernel/Googy-Max-S6/Kernel/arch/arm64/configs/googymax_exynos720-zeroflte_defconfig /home/googy/Kernel/Googy-Max-S6/googymax_exynos720-zeroflte_defconfig
sed "s#^CONFIG_LOCALVERSION=.*#CONFIG_LOCALVERSION=$VER#" /home/googy/Kernel/Googy-Max-S6/googymax_exynos720-zeroflte_defconfig > /home/googy/Kernel/Googy-Max-S6/Kernel/arch/arm64/configs/googymax_exynos720-zeroflte_defconfig

export ARCH=arm64
export SUB_ARCH=arm64

rm -f /home/googy/Kernel/Googy-Max-S6/Kernel/arch/arm64/boot/Image*.*
rm -f /home/googy/Kernel/Googy-Max-S6/Kernel/arch/arm64/boot/.Image*.*
make googymax_exynos720-zeroflte_defconfig || exit 1

make -j4 || exit 1

mkdir -p /home/googy/Kernel/Googy-Max-S6/Out/ramdisk/lib/modules
rm -rf /home/googy/Kernel/Googy-Max-S6/Out/ramdisk/lib/modules/*
find -name '*.ko' -exec cp -av {} /home/googy/Kernel/Googy-Max-S6/Out/ramdisk/lib/modules/ \;
${CROSS_COMPILE}strip --strip-unneeded /home/googy/Kernel/Googy-Max-S6/Out/ramdisk/lib/modules/*

./tools/dtbtool -o /home/googy/Kernel/Googy-Max-S6/Out/dt.img -s 2048 -p ./scripts/dtc/ arch/arm64/boot/dts/

cd /home/googy/Kernel/Googy-Max-S6/Out
./packimg.sh

cd /home/googy/Kernel/Googy-Max-S6/Release
zip -r ../Googy-Max-S6_Kernel_${1}_CWM.zip .

adb push /home/googy/Kernel/Googy-Max-S6/Googy-Max-S6_Kernel_${1}_CWM.zip /sdcard/Googy-Max-S6_Kernel_${1}_CWM.zip

adb kill-server

echo "Googy-Max-S6_Kernel_${1}_CWM.zip READY !"
