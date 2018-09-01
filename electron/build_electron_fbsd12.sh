#!/usr/local/bin/bash

set -e

export BUILDROOT=`pwd`
set -x
ver=`uname -K`

#Building libchromiumcontent chromium-61.0.3163.100
echo "Building LIBCHROMIUMCONTENT ..."
svnlite co -r456719 svn://svn.freebsd.org/ports/head/www/chromium chromium
cd chromium
patch -p1  < ../chromium_make_fbsd12.diff
make configure DISABLE_LICENSES=1 DISABLE_VULNERABILITIES=yes
#sudo chown -R user:group work/chromium-61.0.3163.100/
cd ..
git clone https://github.com/electron/libchromiumcontent.git
cd libchromiumcontent
git checkout 0e760628832e77f72b4975ae0bcae8bb74afbf9c
## For electron v2.0.5
#git checkout 0f50f5e3b3fff53d53f72eb39293e01083480311
patch -p1  --ignore-whitespace < ../libchromiumcontent_111.diff
script/bootstrap
mv ../chromium/work/chromium-61.0.3163.100 src
patch -p1 --ignore-whitespace < ../libchromiumcontent_patches.diff
patch -p1 --ignore-whitespace  -d src/ < ../chromiumv1.diff
patch -p1 --ignore-whitespace  -d src/ < ../libchromiumcontent_bsd.diff
patch -p1 --ignore-whitespace  -d src/ < ../libchromiumcontent_v8.diff
rm patches/v8/025-cherry_pick_cc55747.patch*
script/update -t x64 --skip_gclient
script/build -c static_library -t x64
script/build -c ffmpeg -t x64
#script/build -c native_mksnapshot -t x64
script/create-dist -c static_library -t x64
#script/create-dist  -c native_mksnapshot -t x64

#Building ELECTRON ...
echo "Building ELECTRON ..."
cd $BUILDROOT
git clone https://github.com/electron/electron.git
cd electron/
git checkout v2.0.1
#git checkout v2.0.5
patch  -p1 --ignore-whitespace < ../electron_111.diff
set +e
#this will fail when it tries to download libchromiumcontent library
script/bootstrap.py -v --clang_dir=/usr
set -e
patch  -p1  --ignore-whitespace -d brightray/  < ../electron_brightrayv3.diff
patch  -p1  --ignore-whitespace -d vendor/libchromiumcontent/  < ../electron_vendor_libchromiumcontentv1.diff
mkdir vendor/download/libchromiumcontent
tar -xvf ../libchromiumcontent/libchromiumcontent.tar.bz2 -C vendor/download/libchromiumcontent/
tar -xvf ../libchromiumcontent/libchromiumcontent-static.tar.bz2 -C vendor/download/libchromiumcontent/
script/bootstrap.py -v --clang_dir=/usr
script/build.py -c R
script/create-dist.py
