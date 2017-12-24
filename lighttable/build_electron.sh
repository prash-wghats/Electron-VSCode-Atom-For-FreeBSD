#!/usr/bin/env bash

set -e

export BUILDROOT=`pwd`
set -x

#Building LIBCHROMIUMCONTENT ...
echo "Building LIBCHROMIUMCONTENT ..."

#406565 47.0.2526.111
svnlite co -r406565 svn://svn.freebsd.org/ports/head/www/chromium chromium
cd chromium
patch -p1 < ../chromium_make.diff
rm files/patch-third_party__sfntly__sfntly.gyp files/patch-third_party__sqlite__sqlite.gyp   files/patch-third_party__WebKit__Source__wtf__wtf.gyp files/patch-third_party__khronos__khronos.gyp
make configure
cd ..
git clone https://github.com/electron/libchromiumcontent.git
cd libchromiumcontent
git checkout v47.0.2526.110
script/bootstrap
patch -p1  <../libchromiumcontent.diff
mv ../chromium/work/chromium-47.0.2526.111 vendor/chromium/src
rm vendor/chromium/src/base/process/launch.cc.orig vendor/chromium/src/content/app/content_main_runner.cc.orig
script/apply-patches
patch -p1  -d vendor/chromium/src/ < ../libchromium_src.diff
cp -R chromiumcontent vendor/chromium/src/.
patch -p1  -d vendor/chromium/src/ < ../chromium.diff
cd vendor/chromium/src/

/usr/bin/env CC="cc"  CXX="c++"  GYP_GENERATORS=ninja  GYP_GENERATOR_FLAGS="output_dir=out" GYP_DEFINES="clang_use_chrome_plugins=0  component=static_library linux_breakpad=0  linux_use_heapchecker=0  linux_strip_binary=1  use_aura=1  mac_mas_build=1test_isolation_mode=noop  disable_nacl=1  enable_extensions=1  enable_one_click_signin=1  enable_openmax=1  enable_webrtc=1  werror=  no_gc_sections=1  os_ver=1101001  prefix_dir=/usr/local  python_ver=2.7  use_allocator=none  use_cups=1  linux_link_gsettings=1  linux_link_libpci=1  linux_link_libspeechd=1  libspeechd_h_prefix=speech-dispatcher/  usb_ids_path=/usr/local/share/usbids/usb.ids  want_separate_host_toolset=0  use_system_bzip2=1  use_system_flac=1  use_system_harfbuzz=1  use_system_icu=0  use_system_jsoncpp=1  use_system_libevent=1  use_system_libexif=1  use_system_libjpeg=1  use_system_libpng=1  use_system_libusb=1  use_system_libwebp=1  use_system_libxml=1  use_system_libxslt=1  use_system_nspr=1  use_system_protobuf=0  use_system_re2=0  use_system_snappy=1  use_system_speex=1  use_system_xdg_utils=1  use_system_yasm=1  v8_use_external_startup_data=1  ffmpeg_branding=Chrome proprietary_codecs=1 use_gconf=1 use_pulseaudio=0 clang=1" ac_cv_path_PERL=/usr/local/bin/perl ac_cv_path_PERL_PATH=/usr/local/bin/perl  PERL_USE_UNSAFE_INC=1 PKG_CONFIG=pkgconf PYTHON="/usr/local/bin/python2.7" AR=/usr/bin/ar CFLAGS="-O2 -pipe -I/usr/local/include/atk-1.0 -Wno-unknown-warning-option -fstack-protector -fno-strict-aliasing"  CPPFLAGS=""  CXXFLAGS="-O2 -pipe  -I/usr/local/include/atk-1.0 -Wno-unknown-warning-option -fstack-protector -fno-strict-aliasing"  LDFLAGS=" -fstack-protector" XDG_DATA_HOME=../../../  XDG_CONFIG_HOME=../../../  HOME=../../../ SHELL=/bin/sh CONFIG_SHELL=/bin/sh /usr/local/bin/python2.7  build/gyp_chromium --depth . -Ichromiumcontent/chromiumcontent.gypi chromiumcontent/chromiumcontent.gyp

ninja -C out/Release chromiumcontent_all
cd out/Release
find . -name "lib*.a" -exec cp {} . \;
cp ../../third_party/icu/source/data/in/icudtl.dat .
cd $BUILDROOT/libchromiumcontent/
script/create-dist -c static_library -t x64

cd $BUILDROOT
#Building ELECTRON ...
echo "Building ELECTRON ..."
git clone https://github.com/electron/electron.git
cd electron
git checkout v0.36.5
patch -p1  <../electron_0.36.5.diff
set +e
#this will fail when it tries to download libchromiumcontent library
script/bootstrap.py -v 
set -e
patch -p1   -d vendor/native_mate/ < ../electron_vendor_native_matev1.diff
patch -p1 -d vendor/brightray/ < ../electron_vendor_brightrayv2.diff
patch -p1  -d vendor/brightray/vendor/libchromiumcontent/ < ../electron_vendor_libchromiumcontentv2.diff
unzip ../libchromiumcontent/libchromiumcontent.zip -d vendor/brightray/vendor/download/libchromiumcontent/
unzip ../libchromiumcontent/libchromiumcontent-static.zip -d vendor/brightray/vendor/download/libchromiumcontent/

script/bootstrap.py -v
script/build.py -c R
script/create-dist.py

