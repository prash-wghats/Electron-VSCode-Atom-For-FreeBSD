#!/usr/bin/env bash

set -e

export BUILDROOT=`pwd`
set -x

#Building libchromiumcontent chromium-56.0.2924.87
echo "Building LIBCHROMIUMCONTENT ..."
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
cd $BUILDROOT

#install libsecret 
#pkg install libsecret

#Building APM builtin node ...
echo "Building APM NodeJS ..."
git clone https://github.com/nodejs/node.git
cd node
git checkout v6.9.5
./configure
make -j4
cd ..

echo "Building ATOM ..."
cd $BUILDROOT
export CXXFLAGS=-I/usr/local/include
git clone https://github.com/atom/atom.git
cd atom
git checkout v1.23.0
patch -p1 < ../atom1.diff
set +e
script/build
set -e
patch -p1 < ../atom2.diff
#ln -s /usr/local/bin/node `realpath`/apm/node_modules/atom-package-manager/bin/node
cp ../node/out/Release/node `realpath`/apm/node_modules/atom-package-manager/bin/node
cd apm/node_modules/atom-package-manager/
./bin/npm rebuild
cd $BUILDROOT/atom
mkdir script/node_modules/electron-chromedriver 
mkdir script/node_modules/electron-chromedriver/bin
mkdir script/node_modules/electron-mksnapshot
mkdir script/node_modules/electron-mksnapshot/bin
cp ../electron/dist/chromedriver script/node_modules/electron-chromedriver/bin/.
cp ../electron/dist/mksnapshot script/node_modules/electron-mksnapshot/bin/.
set +e
script/build
#error while building nsfw module
tar -xvf ../nsfw_stub.tar.gz -C node_modules/
script/build
#error while building spellchecker module
set -e
tar -xvf ../spellchecker.tar.gz -C node_modules/
patch -p1 < ../atom3.diff
cd node_modules/nsfw
../../apm/node_modules/atom-package-manager/node_modules/.bin/node-gyp --nodedir ~/.atom/.node-gyp/.node-gyp/iojs-1.6.15/  rebuild
cd $BUILDROOT/atom/node_modules/spellchecker
../../apm/node_modules/atom-package-manager/node_modules/.bin/node-gyp --nodedir ~/.atom/.node-gyp/.node-gyp/iojs-1.6.15/  rebuild
#modify binding.gyp for the following modules to include freebsd
cd $BUILDROOT/atom/node_modules/nslog
../../apm/node_modules/atom-package-manager/node_modules/.bin/node-gyp --nodedir ~/.atom/.node-gyp/.node-gyp/iojs-1.6.15/  rebuild
cd $BUILDROOT/atom/node_modules/keyboard-layout
../../apm/node_modules/atom-package-manager/node_modules/.bin/node-gyp --nodedir ~/.atom/.node-gyp/.node-gyp/iojs-1.6.15/  rebuild
cd $BUILDROOT/atom/node_modules/scrollbar-style
../../apm/node_modules/atom-package-manager/node_modules/.bin/node-gyp --nodedir ~/.atom/.node-gyp/.node-gyp/iojs-1.6.15/  rebuild
# Just making sure the node modules were built
cd $BUILDROOT/atom/node_modules/cached-run-in-this-context
../../apm/node_modules/atom-package-manager/node_modules/.bin/node-gyp --nodedir ~/.atom/.node-gyp/.node-gyp/iojs-1.6.15/  rebuild
cd $BUILDROOT/atom/node_modules/pathwatcher
../../apm/node_modules/atom-package-manager/node_modules/.bin/node-gyp --nodedir ~/.atom/.node-gyp/.node-gyp/iojs-1.6.15/  rebuild
cd $BUILDROOT/atom/node_modules/oniguruma
../../apm/node_modules/atom-package-manager/node_modules/.bin/node-gyp --nodedir ~/.atom/.node-gyp/.node-gyp/iojs-1.6.15/  rebuild
cd $BUILDROOT/atom/node_modules/superstring
../../apm/node_modules/atom-package-manager/node_modules/.bin/node-gyp --nodedir ~/.atom/.node-gyp/.node-gyp/iojs-1.6.15/  rebuild
cd $BUILDROOT/atom/node_modules/git-utils
../../apm/node_modules/atom-package-manager/node_modules/.bin/node-gyp --nodedir ~/.atom/.node-gyp/.node-gyp/iojs-1.6.15/  rebuild
cd $BUILDROOT/atom/node_modules/keytar
../../apm/node_modules/atom-package-manager/node_modules/.bin/node-gyp --nodedir ~/.atom/.node-gyp/.node-gyp/iojs-1.6.15/  rebuild
cd $BUILDROOT/atom/node_modules/fs-admin
../../apm/node_modules/atom-package-manager/node_modules/.bin/node-gyp --nodedir ~/.atom/.node-gyp/.node-gyp/iojs-1.6.15/  rebuild
cd $BUILDROOT/atom/
set +e
cp menus/linux.cson menus/freebsd.cson
cp keymaps/linux.cson keymaps/freebsd.cson
rm -rf node_modules/@atom/nsfw/node_modules
rm -rf node_modules/@atom/nsfw/build
cp -R node_modules/nsfw/build node_modules/@atom/nsfw/.
mkdir electron
cp ../electron/dist/electron-v1.6.15-freebsd-x64.zip electron/.

script/build --compress-artifacts
if [ $? -eq 0 ]
then
	echo "ok"
else
	script/build --compress-artifacts
fi
#./atom/out/Atom/atom
