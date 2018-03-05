#!/usr/local/bin/bash

set -e

export BUILDROOT=`pwd`
set -x
ver=`uname -K`

svnlite co -r446317 svn://svn.freebsd.org/ports/head/www/chromium chromium
cd chromium
rm files/patch-chrome_browser_ui_libgtkui_gtk_ui.cc
make configure DISABLE_VULNERABILITIES=yes
cd ..
git clone https://github.com/electron/libchromiumcontent.git
cd libchromiumcontent
git checkout dbd83b6
if [ "$ver" -lt 1100508 ]
then
	patch -p1 --ignore-whitespace < ../libchromiumcontent_110.diff
else
	patch -p1  --ignore-whitespace < ../libchromiumcontent_111.diff
fi
script/bootstrap
#59.0.3071.115
mv ../chromium/work/chromium-59.0.3071.115 src
mv src/third_party/ffmpeg/BUILD.gn.orig src/third_party/ffmpeg/BUILD.gn
patch -p1 --ignore-whitespace  -d src/ < ../chromiumv1.diff

rm patches/third_party/skia/003-freetype-2.patch
rm patches/third_party/swiftshader/001-gold_ifc.patch

script/update -t x64 --skip_gclient
script/build --no_shared_library -t x64
script/create-dist -c static_library -t x64

#Building ELECTRON ...
echo "Building ELECTRON ..."
cd $BUILDROOT
git clone https://github.com/electron/electron.git
cd electron/
git checkout v1.8.2
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
