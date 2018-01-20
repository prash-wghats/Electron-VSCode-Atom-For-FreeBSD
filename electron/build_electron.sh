#!/usr/local/bin/bash

set -e

export BUILDROOT=`pwd`
set -x
ver=`uname -K`

svnlite co -r456719 svn://svn.freebsd.org/ports/head/www/chromium chromium
cd chromium
patch -p1  < ../chromium_make.diff
make configure DISABLE_LICENSES=1 DISABLE_VULNERABILITIES=yes
cd ..
git clone https://github.com/electron/libchromiumcontent.git
cd libchromiumcontent
git checkout 2bdad00587
if [ "$ver" -lt 1100508 ]
then
	patch -p1 --ignore-whitespace < ../libchromiumcontent_110.diff
else
	patch -p1  --ignore-whitespace < ../libchromiumcontent_111.diff
fi
script/bootstrap
#61.0.3163.100
mv ../chromium/work/chromium-61.0.3163.100 src

patch -p1  < ../libchromiumcontent_patches.diff
rm patches/v8/025-cherry_pick_cc55747.patch*
patch -p1 --ignore-whitespace  -d src/ < ../chromiumv1.diff
patch -p1 --ignore-whitespace  -d src/ < ../libchromiumcontent_bsd.diff
#sudo chown -R prash:wheel src/
script/update -t x64 --skip_gclient
script/build --no_shared_library -t x64
script/create-dist -c static_library -t x64
#Building ELECTRON ...
echo "Building ELECTRON ..."
cd $BUILDROOT
git clone https://github.com/electron/electron.git
cd electron/
git checkout 4dab824c6b7b833a4e3af878b1d021d60822d3e0
if [ "$ver" -lt 1100508 ]
then
	patch  -p1 --ignore-whitespace < ../electron_110.diff
else
	patch  -p1 --ignore-whitespace < ../electron_111.diff
fi

set +e
#this will fail when it tries to download libchromiumcontent library
script/bootstrap.py -v --clang_dir=/usr
set -e
patch  -p1  --ignore-whitespace -d vendor/native_mate/  < ../electron_vendor_native_matev1.diff
patch  -p1  --ignore-whitespace -d brightray/  < ../electron_brightrayv3.diff
patch  -p1  --ignore-whitespace -d vendor/libchromiumcontent/  < ../electron_vendor_libchromiumcontentv1.diff

mkdir vendor/download/libchromiumcontent
unzip ../libchromiumcontent/libchromiumcontent.zip -d vendor/download/libchromiumcontent/
unzip ../libchromiumcontent/libchromiumcontent-static.zip -d vendor/download/libchromiumcontent/
script/bootstrap.py -v --clang_dir=/usr
script/build.py -c R
script/create-dist.py
