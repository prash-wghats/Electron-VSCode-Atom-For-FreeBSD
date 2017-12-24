#!/usr/bin/env bash

set -e
export BUILDROOT=`pwd`
set -x

#Building libchromiumcontent chromium-56.0.2924.87
svnlite co -r435428 svn://svn.freebsd.org/ports/head/www/chromium chromium
cd chromium
patch -p1  <../chromium_make.diff
rm files/patch-third__party_ffmpeg_ffmpeg__generated.gni.orig
make configure
cd ..
git clone https://github.com/electron/libchromiumcontent.git
cd libchromiumcontent
git checkout electron-1-6-x 
patch -p1 < ../libchromiumcontent.diff 
script/bootstrap
mv ../chromium/work/chromium-56.0.2924.87 src
patch -p1  -d src/third_party/ffmpeg/ < patches/third_party/ffmpeg/build_gn.patch
patch -p1  -d src/third_party/icu/ < patches/third_party/icu/build_gn.patch
patch -p1  -d src/v8/ < patches/v8/build_gn.patch
patch -p1  -d src/ < patches/build_gn.patch 
rm patches/third_party/ffmpeg/build_gn.patch patches/third_party/icu/build_gn.patch patches/v8/build_gn.patch patches/build_gn.patch
rm src/base/process/launch.h.orig src/content/browser/renderer_host/*.orig src/chrome/browser/ui/libgtkui/*.orig src/content/app/*.orig src/content/renderer/*.orig
patch -p1  --ignore-whitespace -d src/ < ../chromiumv2.diff
script/update -t x64
script/build --no_shared_library -t x64
script/create-dist -c static_library -t x64
cd $BUILDROOT

#Building ELECTRON ...
echo "Building ELECTRON ..."
git clone https://github.com/electron/electron.git
#node 7.4
cd electron
git checkout v1.6.15
patch  -p1 --ignore-whitespace < ../electronv3.diff
set +e
#this will fail when it tries to download libchromiumcontent library
script/bootstrap.py -v --clang_dir=/usr
set -e
patch  -p1  --ignore-whitespace -d vendor/native_mate/  < ../electron_vendor_native_matev1.diff
patch  -p1  --ignore-whitespace -d vendor/brightray/  < ../electron_brightrayv3.diff
patch  -p1  --ignore-whitespace -d vendor/brightray/vendor/libchromiumcontent/  < ../electron_vendor_libchromiumcontentv1.diff
mkdir vendor/brightray/vendor/download/libchromiumcontent
unzip ../libchromiumcontent/libchromiumcontent.zip -d vendor/brightray/vendor/download/libchromiumcontent/
unzip ../libchromiumcontent/libchromiumcontent-static.zip -d vendor/brightray/vendor/download/libchromiumcontent/
cp ../pdf_viewer_resources.pak vendor/brightray/vendor/download/libchromiumcontent/static_library/.
script/bootstrap.py -v --clang_dir=/usr
script/build.py -c R
script/create-dist.py
#electron/dist/electron
