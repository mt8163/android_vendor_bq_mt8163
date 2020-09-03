#!/bin/sh

rootdirectory="$PWD"
dirs="frameworks/av frameworks/base frameworks/native hardware/interfaces packages/apps/FMRadio system/core system/netd external/wpa_supplicant_8 system/bt"

for dir in $dirs ; do
	cd $rootdirectory
	cd $dir
	echo "Cleaning $dir patches..."
	git checkout -- . && git clean -df
done

echo "Done!"
cd $rootdirectory
