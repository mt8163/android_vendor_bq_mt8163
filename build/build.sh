#!/bin/bash

#
# Android compilation script.
#
# Copyright (C) 2020 R0rt1z2.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>
#

# Colors
BLUE='\033[0;34m'
CYAN='\033[0;96m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
LIGHT_RED='\033[1;31m'
LIGHT_BLUE='\033[1;34m'
PURPLE='\033[0;35m'
RC='\033[0m'

# Build values (do not edit those)
DATE=$(date +"%Y-%m-%d")
VERSION=$3
VARIANT=$2
DEVICE=$1
LOG=build_log-bootleg-$VERSION-$DEVICE-$VARIANT-$DATE.log

# Extra values (you can edit those if you want)
INSTALL_CLEAN='0'
CCACHE='0'

# Check return of command
function check_ret() {
    if [ "$#" -eq "0" ]; then
        echo -ne "$RED""ERROR: Missing arguments!""$RC"
        echo ""
        exit 1
    fi

    RET=$($1 2> /dev/null)
    RES=$?

    if [ "$RES" != "0" ]; then
        echo -ne "$YELLOW""ERROR: Failed to execute '$1'. Exit code: $RES""$RC"
        echo ""
        exit 1
    fi
}

# Check/Manage the build log
function check_log() {
    if [ -f "$(pwd)/$LOG" ]; then
        echo -ne "$YELLOW""INFO: Regenerating build log...""$RC"
        echo ""
        rm "$LOG"
        check_ret "touch $LOG"
    else
        check_ret "touch $LOG"
    fi
}

# Check current user
function check_user() {
    if [ "$(id -u)" -eq "0" ]; then
        echo -ne "$YELLOW""WARNING: Building as root may cause problems!""$RC"
        echo ""
        read -p "Do you want to continue (y/n)? " choice
        case "$choice" in 
            y|Y ) echo "";;
            n|N ) echo ""; exit 0;;
            * ) echo -ne "$RED""ERROR: Invalid option: $choice""$RC"; echo ""; echo ""; exit 1;;
        esac
    fi
}

# Check given arguments
function check_argvs() {
    if [ -z "$DEVICE" ]; then
        echo ""
        echo -ne "$RED""ERROR: First argument is missing &/or empty...""$RC"
        echo ""
        echo ""
        exit 1
    fi
    if [[ "$DEVICE" == *"-h"* ]]; then
        echo "    USAGE:"
        echo "        ./build.sh device variant version"
        echo ""
        exit 0
    fi
    if [ -z "$VARIANT" ]; then
        echo ""
        echo -ne "$RED""ERROR: Second argument is missing &/or empty...""$RC"
        echo ""
        echo ""
        exit 1
    fi
    if [ -z "$VERSION" ]; then
        echo ""
        echo -ne "$RED""ERROR: Third argument is missing &/or empty...""$RC"
        echo ""
        echo ""
        exit 1
    fi
}

# Check build result (based in the log)
function check_build() {
    SUCCEED=$(cat $LOG | tail | grep "make completed successfully")
    RES1=$?
    FAILED=$(cat $LOG | tail | grep "failed to build some targets")
    RES2=$?

    if [ "$RES1" -eq "0" ]; then
        echo -ne "$GREEN""INFO: Build completed succsesfully!""$RC"
        echo ""
        echo ""
        exit 0
    elif [ "$RES2" -eq "0" ]; then
        echo -ne "$LIGHT_RED""FATAL: Build failed... Check '$LOG' for details!""$RC"
        echo ""
        echo ""
        exit 1
    else
        echo -ne "$RED""ERROR: Could not determine the result of the build...""$RC"
        echo ""
        echo ""
        exit 1
    fi
}

# Print fancy banner
echo ""
echo -ne "$CYAN""           ___              _     __                                    \n""$RC"
echo -ne "$CYAN""          /  __\ ___   ___ | |_  / /  ___  __ _  __ _  ___ _ __ ___     \n""$RC"
echo -ne "$CYAN""          /__\/// _ \ / _ \| __|/ /  / _ \/ _\ |/ _ \|/ _ \ __/ __|     \n""$RC"
echo -ne "$CYAN""         / \/  \ (_) | (_) | |_/ /__|  __/ (_| | (_| |  __/ |  \__ \    \n""$RC"
echo -ne "$CYAN""         \_____/\___/ \___/ \__\____/\___|\__, |\__, |\___|_|  |___/    \n""$RC"
echo -ne "$CYAN""                                          |___/ |___/                   \n""$RC"   

# First sanity checks
check_argvs
check_user
check_log

sleep 1.5

# Export build variables
echo -ne "$YELLOW""INFO: Setting build exports...\n""$RC"
check_ret "export ALLOW_MISSING_DEPENDENCIES=true"
check_ret "export ANDROID_JACK_VM_ARGS="-Xmx4g -XX:+TieredCompilation -Dfile.encoding=UTF-8""
check_ret "export _JAVA_OPTIONS=-Xmx3048m"
check_ret "export SERVER_NB_COMPILE=2"
check_ret "export LANG=C"
check_ret "export LC_ALL=C"
check_ret "export LC=ALL"
check_ret "export USE_CCACHE=$CCACHE"

# Prepare env
echo -ne "$YELLOW""INFO: Preparing the build environment...\n""$RC"
source ./build/envsetup.sh

# Lunch
echo -ne "$YELLOW""INFO: Lunching bootleg_$DEVICE-$VARIANT...\n""$RC"
lunch bootleg_$DEVICE-$VARIANT

# Is installclean option enabled?
if [ "$INSTALL_CLEAN" -eq "1" ]; then
    echo -ne "$YELLOW""INFO: Make install clean enabled. Doing installclean before build...\n""$RC"
    make installclean -j"$(nproc)"
fi

# Make bacon
echo -ne "$YELLOW""INFO: Making bacon/Building for $DEVICE... This will take a while depending on your computer...\n""$RC"
mka bacon -j"$(nproc)" | tee "$LOG"

# Flush the log
sync; sleep 3

check_build
