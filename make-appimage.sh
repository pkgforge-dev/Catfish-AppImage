#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q catfish | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/org.xfce.catfish.svg
export DESKTOP=/usr/share/applications/org.xfce.Catfish.desktop
export PATH_MAPPING='/usr/share/catfish:${SHARUN_DIR}/share/catfish'
export DEPLOY_PYTHON=1
export ALWAYS_SOFTWARE=1

# Deploy dependencies
quick-sharun /usr/bin/catfish /usr/share/catfish /usr/lib/libgtk-3.so*  
  
# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
