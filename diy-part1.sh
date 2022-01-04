#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# R4A-100M 的breed直刷
## 参考: https://github.com/unkaer/Actions-OpenWrt-Xiaomi-R4A/blob/main/diy-part1.sh

## 1.修改 mt7628an_xiaomi_mi-router-4.dtsi
export shanchu1=$(grep  -a -n -e 'fixed-partitions' target/linux/ramips/dts/mt7628an_xiaomi_mi-router-4.dtsi|cut -d ":" -f 1)
export shanchu2=$(grep  -a -n -e '&state_default {' target/linux/ramips/dts/mt7628an_xiaomi_mi-router-4.dtsi|cut -d ":" -f 1)
export shanchu2=$(expr $shanchu2 - 1)
export shanchu2=$(echo $shanchu2"d")
sed -i $shanchu1,$shanchu2 target/linux/ramips/dts/mt7628an_xiaomi_mi-router-4.dtsi
grep  -Pzo '\t*compatible = "fixed-partitions";[\s\S]*};[\s]*};[\s]*};[\s]*};' target/linux/ramips/dts/mt7621_youhua_wr1200js.dts > youhua.txt
echo "" >> youhua.txt
echo "" >> youhua.txt
export shanchu1=$(expr $shanchu1 - 1)
export shanchu1=$(echo $shanchu1"r")
sed -i "$shanchu1 youhua.txt" target/linux/ramips/dts/mt7628an_xiaomi_mi-router-4.dtsi
rm -rf youhua.txt

## 2.修改mt76x8.mk
export imsize1=$(grep  -a -n -e 'define Device/xiaomi_mi-router-4a-100m' target/linux/ramips/image/mt76x8.mk|cut -d ":" -f 1)
export imsize1=$(expr $imsize1 + 1)
export imsize1=$(echo $imsize1"s")
sed -i "$imsize1/IMAGE_SIZE := .*/IMAGE_SIZE := 16064k/" target/linux/ramips/image/mt76x8.mk
