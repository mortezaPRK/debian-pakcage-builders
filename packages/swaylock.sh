#!/bin/bash

##
# Example:
# 
#   docker run --rm -v "$(pwd):/out" <image>:<tag> ./swaylock.sh
##

set -ex

BUILD_DIR=$(mktemp -d)

cd $BUILD_DIR
git clone --depth 1 --branch 1.5 https://github.com/swaywm/swaylock.git
cd swaylock/
apt install -y wayland-protocols scdoc libwayland-dev libxkbcommon-dev libcairo2-dev libpam0g-dev
meson build
ninja -C build
USER=root dh_make --single --yes --createorig -p swaylock_1.5

# fix build error
echo 'export DEB_CFLAGS_MAINT_APPEND  = -Wno-error=date-time ' >> debian/rules

dh_auto_configure --buildsystem=meson
dpkg-buildpackage -rfakeroot -us -uc -b

mv $BUILD_DIR/swaylock_1.5-1_amd64.deb ${OUT_DIR:-/out}
