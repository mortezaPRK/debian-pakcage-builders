#!/bin/bash

##
# Example:
# 
#   docker run --rm -v "$(pwd):/out" <image>:<tag> ./swaykbdd.sh
##

set -ex

BUILD_DIR=$(mktemp -d)

cd $BUILD_DIR
git clone --depth 1 --branch v1.0 https://github.com/artemsen/swaykbdd.git
cd swaykbdd/
apt install -y libjson-c-dev
meson build
ninja -C build
USER=root dh_make --single --yes --createorig -p swaykbdd_1.0
dh_auto_configure --buildsystem=meson
dpkg-buildpackage -rfakeroot -us -uc -b

mv $BUILD_DIR/swaykbdd_1.0-1_amd64.deb ${OUT_DIR:-/out}
