#!/usr/local/bin/bash

set -e

export BUILDROOT=`pwd`
set -x
svnlite co -r442282 svn://svn.freebsd.org/ports/head/www/chromium chromium
cd chromium
rm files/patch-gpu_command__buffer_service_program__manager.cc files/patch-gpu_config_gpu__control__list.cc files/patch-third__party_leveldatabase_env__chromium.cc
make configure DISABLE_VULNERABILITIES=yes
cd ..
git clone https://github.com/electron/libchromiumcontent.git
cd libchromiumcontent
git checkout e301597
patch -p1  < ../libchromiumcontent.diff 
script/bootstrap
mv ../chromium/work/chromium-58.0.3029.110 src
mv src/third_party/ffmpeg/BUILD.gn.orig src/third_party/ffmpeg/BUILD.gn
patch -p1  --ignore-whitespace -d src/ < ../chromiumv1.diff
script/update -t x64
script/build --no_shared_library -t x64
script/create-dist -c static_library -t x64
#Building ELECTRON ...
echo "Building ELECTRON ..."
cd $BUILDROOT
git clone https://github.com/electron/electron.git
cd electron/
#git checkout v1.7.3
git checkout v1.7.7
patch  -p1 --ignore-whitespace < ../electronv3.diff
set +e
#this will fail when it tries to download libchromiumcontent library
script/bootstrap.py -v --clang_dir=/usr
set -e
patch  -p1  --ignore-whitespace -d vendor/native_mate/  < ../electron_vendor_native_matev1.diff
patch  -p1  --ignore-whitespace -d brightray/  < ../electron_brightrayv3.diff
patch  -p1  --ignore-whitespace -d vendor/libchromiumcontent/  < ../electron_vendor_libchromiumcontentv1.diff
patch  -p1  --ignore-whitespace < ../electron_node_modules.diff
mkdir vendor/download/libchromiumcontent
unzip ../libchromiumcontent/libchromiumcontent.zip -d vendor/download/libchromiumcontent/
unzip ../libchromiumcontent/libchromiumcontent-static.zip -d vendor/download/libchromiumcontent/
script/bootstrap.py -v --clang_dir=/usr
script/build.py -c R
script/create-dist.py
#Building VSCODE
echo "Building VSCODE"
cd $BUILDROOT
git clone https://github.com/microsoft/vscode
cd vscode/
#v1.17.2
git checkout 1.17.2
patch -p1  < ../vscodev1.diff
scripts/npm.sh install --arch=x64
tar -xvf ../nsfw_stub.tar.gz -C node_modules/
#cd node_modules/nsfw/
#node /usr/local/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js rebuild
#cd ../..
mkdir build/lib/watch/node_modules
tar -xvf ../nsfw_stub.tar.gz -C build/lib/watch/node_modules/
#cd build/lib/watch/node_modules/nsfw/
#node /usr/local/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js rebuild
#cd ../../../../../
scripts/npm.sh install --arch=x64
#git clone https://github.com/roblourens/ripgrep.git
#git checkout 0.5.1-patch.0
#cd ripgrep; cargo build --release
#./target/release/rg
mkdir node_modules/vscode-ripgrep/bin
cp ../rg node_modules/vscode-ripgrep/bin/.
./node_modules/.bin/gulp compile
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BUILDROOT/electron/dist/ 
../electron/dist/electron .
