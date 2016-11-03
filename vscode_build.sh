#!/usr/local/bin/bash

set -e

export BUILDROOT=`pwd`
set -x
ver=`uname -K`

#Building LIBCHROMIUMCONTENT 52.0.2743.116...
echo "Building LIBCHROMIUMCONTENT 52.0.2743.116..."
svnlite co -r426525 svn://svn.freebsd.org/ports/head/www/chromium chromium
cd chromium
patch -p1 --ignore-whitespace < ../chromium_make.diff
rm files/patch-third__party_WebKit_Source_platform_text_CharacterPropertyDataGenerator.cpp
make configure
cd ..
git clone https://github.com/atom/libchromiumcontent.git
cd libchromiumcontent/
git checkout c5cf295ef9
cd vendor/python-patch/
git submodule update --init --recursive
cd ../../
patch -p1  < ../libchromiumcontent.diff
ln -s /usr/ports/www/chromium/work/chromium-52.0.2743.116/ src
set +e
rm src/base/process/launch.cc.orig
rm src/content/app/content_main_runner.cc.orig
rm src/chrome/chrome_resources.gyp.orig
cp src/third_party/re2/re2.gyp.orig src/third_party/re2/re2.gyp
set -e
script/apply-patches
cp -R chromiumcontent/ src/chromiumcontent
patch -p1  -d src/ < ../libchromiumcontent_src.diff
rm -rf src/out/
cd src
if [ "$ver" -lt 1100508 ]
then
	/usr/bin/env CC="cc"  CXX="c++"  GYP_GENERATORS=ninja  GYP_GENERATOR_FLAGS="output_dir=out" GYP_DEFINES="clang_use_chrome_plugins=0  component=static_library  linux_breakpad=0  linux_use_heapchecker=0  linux_strip_binary=1  use_aura=1  mac_mas_build=1 test_isolation_mode=noop  disable_nacl=1  enable_extensions=1  enable_one_click_signin=1  enable_openmax=1  enable_webrtc=1  werror=  no_gc_sections=1  OS=freebsd  os_ver=1100122  prefix_dir=/usr/local  python_ver=2.7  use_allocator=none  use_cups=1  linux_link_gsettings=1  linux_link_libpci=1  linux_link_libspeechd=1  libspeechd_h_prefix=speech-dispatcher/  usb_ids_path=/usr/local/share/usbids/usb.ids  want_separate_host_toolset=0  use_system_bzip2=1  use_system_flac=1  use_system_harfbuzz=1  use_system_icu=0  use_system_jsoncpp=1  use_system_libevent=1  use_system_libexif=1  use_system_libjpeg=1  use_system_libpng=1  use_system_libusb=1  use_system_libwebp=0  use_system_libxml=1  use_system_libxslt=1  use_system_nspr=1  use_system_protobuf=0  use_system_re2=0  use_system_snappy=1  use_system_speex=1  use_system_xdg_utils=1  use_system_yasm=1  v8_use_external_startup_data=1  google_api_key=AIzaSyBsp9n41JLW8jCokwn7vhoaMejDFRd1mp8  google_default_client_id=996322985003.apps.googleusercontent.com  google_default_client_secret=IR1za9-1VK0zZ0f_O8MVFicn ffmpeg_branding=Chrome proprietary_codecs=1 use_gconf=1 use_pulseaudio=0 clang=1" ac_cv_path_PERL=/usr/local/bin/perl ac_cv_path_PERL_PATH=/usr/local/bin/perl PKG_CONFIG=pkgconf PYTHON="/usr/local/bin/python2.7" AR=/usr/bin/ar CFLAGS="-O2 -pipe  -isystem/usr/local/include -I/usr/local/include/atk-1.0 -Wno-unknown-warning-option -D_LIBCPP_TRIVIAL_PAIR_COPY_CTOR=1 -fstack-protector -fno-strict-aliasing"  CPPFLAGS=""  CXXFLAGS="-O2 -pipe -isystem/usr/local/include -I/usr/local/include/atk-1.0 -Wno-unknown-warning-option -D_LIBCPP_TRIVIAL_PAIR_COPY_CTOR=1 -fstack-protector -fno-strict-aliasing "  LDFLAGS=" -fstack-protector" XDG_DATA_HOME=/usr/ports/www/chromium/work  XDG_CONFIG_HOME=/usr/ports/www/chromium/work  HOME=/usr/ports/www/chromium/work SHELL=/bin/sh CONFIG_SHELL=/bin/sh /usr/local/bin/python2.7  build/gyp_chromium --depth . -Ichromiumcontent/chromiumcontent.gypi chromiumcontent/chromiumcontent.gyp
	#/usr/bin/env CC="cc"  CXX="c++"  GYP_GENERATORS=ninja  GYP_GENERATOR_FLAGS="output_dir=out_component" GYP_DEFINES="clang_use_chrome_plugins=0  component=shared_library  linux_breakpad=0  linux_use_heapchecker=0  linux_strip_binary=1  use_aura=1  mac_mas_build=1 test_isolation_mode=noop  disable_nacl=1  enable_extensions=1  enable_one_click_signin=1  enable_openmax=1  enable_webrtc=1  werror=  no_gc_sections=1  OS=freebsd  os_ver=1100122  prefix_dir=/usr/local  python_ver=2.7  use_allocator=none  use_cups=1  linux_link_gsettings=1  linux_link_libpci=1  linux_link_libspeechd=1  libspeechd_h_prefix=speech-dispatcher/  usb_ids_path=/usr/local/share/usbids/usb.ids  want_separate_host_toolset=0  use_system_bzip2=1  use_system_flac=1  use_system_harfbuzz=1  use_system_icu=0  use_system_jsoncpp=1  use_system_libevent=1  use_system_libexif=1  use_system_libjpeg=1  use_system_libpng=1  use_system_libusb=1  use_system_libwebp=0  use_system_libxml=1  use_system_libxslt=1  use_system_nspr=1  use_system_protobuf=0  use_system_re2=0  use_system_snappy=1  use_system_speex=1  use_system_xdg_utils=1  use_system_yasm=1  v8_use_external_startup_data=1  google_api_key=AIzaSyBsp9n41JLW8jCokwn7vhoaMejDFRd1mp8  google_default_client_id=996322985003.apps.googleusercontent.com  google_default_client_secret=IR1za9-1VK0zZ0f_O8MVFicn ffmpeg_branding=Chrome proprietary_codecs=1 use_gconf=1 use_pulseaudio=0 clang=1" ac_cv_path_PERL=/usr/local/bin/perl ac_cv_path_PERL_PATH=/usr/local/bin/perl PKG_CONFIG=pkgconf PYTHON="/usr/local/bin/python2.7" AR=/usr/bin/ar CFLAGS="-O2 -pipe  -isystem/usr/local/include -I/usr/local/include/atk-1.0 -Wno-unknown-warning-option -D_LIBCPP_TRIVIAL_PAIR_COPY_CTOR=1 -fstack-protector -fno-strict-aliasing"  CPPFLAGS=""  CXXFLAGS="-O2 -pipe -isystem/usr/local/include -I/usr/local/include/atk-1.0 -Wno-unknown-warning-option -D_LIBCPP_TRIVIAL_PAIR_COPY_CTOR=1 -fstack-protector -fno-strict-aliasing "  LDFLAGS=" -fstack-protector" XDG_DATA_HOME=/usr/ports/www/chromium/work  XDG_CONFIG_HOME=/usr/ports/www/chromium/work  HOME=/usr/ports/www/chromium/work SHELL=/bin/sh CONFIG_SHELL=/bin/sh /usr/local/bin/python2.7  build/gyp_chromium --depth . -Ichromiumcontent/chromiumcontent.gypi chromiumcontent/chromiumcontent.gyp
    /usr/bin/env CC="cc"  CXX="c++"  GYP_GENERATORS=ninja  GYP_GENERATOR_FLAGS="output_dir=out_ffmpeg" GYP_DEFINES="clang_use_chrome_plugins=0   linux_breakpad=0  linux_use_heapchecker=0  linux_strip_binary=1  use_aura=1  mac_mas_build=1 test_isolation_mode=noop  disable_nacl=1  enable_extensions=1  enable_one_click_signin=1  enable_openmax=1  enable_webrtc=1  werror=  no_gc_sections=1  OS=freebsd  os_ver=1100122  prefix_dir=/usr/local  python_ver=2.7  use_allocator=none  use_cups=1  linux_link_gsettings=1  linux_link_libpci=1  linux_link_libspeechd=1  libspeechd_h_prefix=speech-dispatcher/  usb_ids_path=/usr/local/share/usbids/usb.ids  want_separate_host_toolset=0  use_system_bzip2=1  use_system_flac=1  use_system_harfbuzz=1  use_system_icu=0  use_system_jsoncpp=1  use_system_libevent=1  use_system_libexif=1  use_system_libjpeg=1  use_system_libpng=1  use_system_libusb=1  use_system_libwebp=0  use_system_libxml=1  use_system_libxslt=1  use_system_nspr=1  use_system_protobuf=0  use_system_re2=0  use_system_snappy=1  use_system_speex=1  use_system_xdg_utils=1  use_system_yasm=1  v8_use_external_startup_data=1  google_api_key=AIzaSyBsp9n41JLW8jCokwn7vhoaMejDFRd1mp8  google_default_client_id=996322985003.apps.googleusercontent.com  google_default_client_secret=IR1za9-1VK0zZ0f_O8MVFicn ffmpeg_branding=Chromium proprietary_codecs=1 use_gconf=1 use_pulseaudio=0 clang=1" ac_cv_path_PERL=/usr/local/bin/perl ac_cv_path_PERL_PATH=/usr/local/bin/perl PKG_CONFIG=pkgconf PYTHON="/usr/local/bin/python2.7" AR=/usr/bin/ar CFLAGS="-O2 -pipe  -isystem/usr/local/include -I/usr/local/include/atk-1.0 -Wno-unknown-warning-option -D_LIBCPP_TRIVIAL_PAIR_COPY_CTOR=1 -fstack-protector -fno-strict-aliasing"  CPPFLAGS=""  CXXFLAGS="-O2 -pipe -isystem/usr/local/include -I/usr/local/include/atk-1.0 -Wno-unknown-warning-option -D_LIBCPP_TRIVIAL_PAIR_COPY_CTOR=1 -fstack-protector -fno-strict-aliasing "  LDFLAGS=" -fstack-protector" XDG_DATA_HOME=/usr/ports/www/chromium/work  XDG_CONFIG_HOME=/usr/ports/www/chromium/work  HOME=/usr/ports/www/chromium/work SHELL=/bin/sh CONFIG_SHELL=/bin/sh /usr/local/bin/python2.7  build/gyp_chromium --depth . -Ichromiumcontent/chromiumcontent.gypi chromiumcontent/chromiumcontent.gyp
else
	/usr/bin/env CC="cc"  CXX="c++"  GYP_GENERATORS=ninja  GYP_GENERATOR_FLAGS="output_dir=out" GYP_DEFINES="clang_use_chrome_plugins=0  component=static_library  linux_breakpad=0  linux_use_heapchecker=0  linux_strip_binary=1  use_aura=1  mac_mas_build=1 test_isolation_mode=noop  disable_nacl=1  enable_extensions=1  enable_one_click_signin=1  enable_openmax=1  enable_webrtc=1  werror=  no_gc_sections=1  OS=freebsd  os_ver=1100122  prefix_dir=/usr/local  python_ver=2.7  use_allocator=none  use_cups=1  linux_link_gsettings=1  linux_link_libpci=1  linux_link_libspeechd=1  libspeechd_h_prefix=speech-dispatcher/  usb_ids_path=/usr/local/share/usbids/usb.ids  want_separate_host_toolset=0  use_system_bzip2=1  use_system_flac=1  use_system_harfbuzz=1  use_system_icu=0  use_system_jsoncpp=1  use_system_libevent=1  use_system_libexif=1  use_system_libjpeg=1  use_system_libpng=1  use_system_libusb=1  use_system_libwebp=0  use_system_libxml=1  use_system_libxslt=1  use_system_nspr=1  use_system_protobuf=0  use_system_re2=0  use_system_snappy=1  use_system_speex=1  use_system_xdg_utils=1  use_system_yasm=1  v8_use_external_startup_data=1  google_api_key=AIzaSyBsp9n41JLW8jCokwn7vhoaMejDFRd1mp8  google_default_client_id=996322985003.apps.googleusercontent.com  google_default_client_secret=IR1za9-1VK0zZ0f_O8MVFicn ffmpeg_branding=Chrome proprietary_codecs=1 use_gconf=1 use_pulseaudio=0 clang=1" ac_cv_path_PERL=/usr/local/bin/perl ac_cv_path_PERL_PATH=/usr/local/bin/perl PKG_CONFIG=pkgconf PYTHON="/usr/local/bin/python2.7" AR=/usr/bin/ar CFLAGS="-O2 -pipe  -isystem/usr/local/include -I/usr/local/include/atk-1.0 -Wno-unknown-warning-option -fstack-protector -fno-strict-aliasing"  CPPFLAGS=""  CXXFLAGS="-O2 -pipe -isystem/usr/local/include -I/usr/local/include/atk-1.0 -Wno-unknown-warning-option  -fstack-protector -fno-strict-aliasing "  LDFLAGS=" -fstack-protector" XDG_DATA_HOME=/usr/ports/www/chromium/work  XDG_CONFIG_HOME=/usr/ports/www/chromium/work  HOME=/usr/ports/www/chromium/work SHELL=/bin/sh CONFIG_SHELL=/bin/sh /usr/local/bin/python2.7  build/gyp_chromium --depth . -Ichromiumcontent/chromiumcontent.gypi chromiumcontent/chromiumcontent.gyp
	#/usr/bin/env CC="cc"  CXX="c++"  GYP_GENERATORS=ninja  GYP_GENERATOR_FLAGS="output_dir=out_component" GYP_DEFINES="clang_use_chrome_plugins=0  component=shared_library  linux_breakpad=0  linux_use_heapchecker=0  linux_strip_binary=1  use_aura=1  mac_mas_build=1 test_isolation_mode=noop  disable_nacl=1  enable_extensions=1  enable_one_click_signin=1  enable_openmax=1  enable_webrtc=1  werror=  no_gc_sections=1  OS=freebsd  os_ver=1100122  prefix_dir=/usr/local  python_ver=2.7  use_allocator=none  use_cups=1  linux_link_gsettings=1  linux_link_libpci=1  linux_link_libspeechd=1  libspeechd_h_prefix=speech-dispatcher/  usb_ids_path=/usr/local/share/usbids/usb.ids  want_separate_host_toolset=0  use_system_bzip2=1  use_system_flac=1  use_system_harfbuzz=1  use_system_icu=0  use_system_jsoncpp=1  use_system_libevent=1  use_system_libexif=1  use_system_libjpeg=1  use_system_libpng=1  use_system_libusb=1  use_system_libwebp=0  use_system_libxml=1  use_system_libxslt=1  use_system_nspr=1  use_system_protobuf=0  use_system_re2=0  use_system_snappy=1  use_system_speex=1  use_system_xdg_utils=1  use_system_yasm=1  v8_use_external_startup_data=1  google_api_key=AIzaSyBsp9n41JLW8jCokwn7vhoaMejDFRd1mp8  google_default_client_id=996322985003.apps.googleusercontent.com  google_default_client_secret=IR1za9-1VK0zZ0f_O8MVFicn ffmpeg_branding=Chrome proprietary_codecs=1 use_gconf=1 use_pulseaudio=0 clang=1" ac_cv_path_PERL=/usr/local/bin/perl ac_cv_path_PERL_PATH=/usr/local/bin/perl PKG_CONFIG=pkgconf PYTHON="/usr/local/bin/python2.7" AR=/usr/bin/ar CFLAGS="-O2 -pipe  -isystem/usr/local/include -I/usr/local/include/atk-1.0 -Wno-unknown-warning-option  -fstack-protector -fno-strict-aliasing"  CPPFLAGS=""  CXXFLAGS="-O2 -pipe -isystem/usr/local/include -I/usr/local/include/atk-1.0 -Wno-unknown-warning-option  -fstack-protector -fno-strict-aliasing "  LDFLAGS=" -fstack-protector" XDG_DATA_HOME=/usr/ports/www/chromium/work  XDG_CONFIG_HOME=/usr/ports/www/chromium/work  HOME=/usr/ports/www/chromium/work SHELL=/bin/sh CONFIG_SHELL=/bin/sh /usr/local/bin/python2.7  build/gyp_chromium --depth . -Ichromiumcontent/chromiumcontent.gypi chromiumcontent/chromiumcontent.gyp
	/usr/bin/env CC="cc"  CXX="c++"  GYP_GENERATORS=ninja  GYP_GENERATOR_FLAGS="output_dir=out_ffmpeg" GYP_DEFINES="clang_use_chrome_plugins=0   linux_breakpad=0  linux_use_heapchecker=0  linux_strip_binary=1  use_aura=1  mac_mas_build=1 test_isolation_mode=noop  disable_nacl=1  enable_extensions=1  enable_one_click_signin=1  enable_openmax=1  enable_webrtc=1  werror=  no_gc_sections=1  OS=freebsd  os_ver=1100122  prefix_dir=/usr/local  python_ver=2.7  use_allocator=none  use_cups=1  linux_link_gsettings=1  linux_link_libpci=1  linux_link_libspeechd=1  libspeechd_h_prefix=speech-dispatcher/  usb_ids_path=/usr/local/share/usbids/usb.ids  want_separate_host_toolset=0  use_system_bzip2=1  use_system_flac=1  use_system_harfbuzz=1  use_system_icu=0  use_system_jsoncpp=1  use_system_libevent=1  use_system_libexif=1  use_system_libjpeg=1  use_system_libpng=1  use_system_libusb=1  use_system_libwebp=0  use_system_libxml=1  use_system_libxslt=1  use_system_nspr=1  use_system_protobuf=0  use_system_re2=0  use_system_snappy=1  use_system_speex=1  use_system_xdg_utils=1  use_system_yasm=1  v8_use_external_startup_data=1  google_api_key=AIzaSyBsp9n41JLW8jCokwn7vhoaMejDFRd1mp8  google_default_client_id=996322985003.apps.googleusercontent.com  google_default_client_secret=IR1za9-1VK0zZ0f_O8MVFicn ffmpeg_branding=Chromium proprietary_codecs=1 use_gconf=1 use_pulseaudio=0 clang=1" ac_cv_path_PERL=/usr/local/bin/perl ac_cv_path_PERL_PATH=/usr/local/bin/perl PKG_CONFIG=pkgconf PYTHON="/usr/local/bin/python2.7" AR=/usr/bin/ar CFLAGS="-O2 -pipe  -isystem/usr/local/include -I/usr/local/include/atk-1.0 -Wno-unknown-warning-option  -fstack-protector -fno-strict-aliasing"  CPPFLAGS=""  CXXFLAGS="-O2 -pipe -isystem/usr/local/include -I/usr/local/include/atk-1.0 -Wno-unknown-warning-option  -fstack-protector -fno-strict-aliasing "  LDFLAGS=" -fstack-protector" XDG_DATA_HOME=/usr/ports/www/chromium/work  XDG_CONFIG_HOME=/usr/ports/www/chromium/work  HOME=/usr/ports/www/chromium/work SHELL=/bin/sh CONFIG_SHELL=/bin/sh /usr/local/bin/python2.7  build/gyp_chromium --depth . -Ichromiumcontent/chromiumcontent.gypi chromiumcontent/chromiumcontent.gyp
fi
ninja -C out/Release chromiumcontent_all
#ninja -C out_component/Release chromiumcontent_all
ninja -C out_ffmpeg/Release ffmpeg
cd out/Release
find . -name "lib*.a" -exec cp {} . \;
cd ../../out_component/Release
find . -name "lib*.a" -exec cp {} . \;
cd ../../
cp third_party/icu/common/icudtl.dat out/Release/.
cd $BUILDROOT/libchromiumcontent/
./script/create-dist -c static_library -t x64
#zipped files will be placed in libchromiumcontent/libchromiumcontent-static.zip, libchromiumcontent.zip
cd $BUILDROOT
#Building ELECTRON ...
echo "Building ELECTRON ..."
git clone https://github.com/electron/electron.git
cd electron/
git checkout v1.3.7
if [ "$ver" -lt 1100508 ]
then
	patch -p1 --ignore-whitespace < ../electronv110.diff
else
	patch -p1  --ignore-whitespace < ../electronv111.diff
fi

set +e
#this will fail when it tries to download libchromiumcontent library
script/bootstrap.py -v --clang_dir=/usr
set -e
patch  -p1  -d vendor/native_mate/  < ../electron_vendor_native_matev1.diff
patch  -p1  -d vendor/brightray/  < ../electron_vendor_brightrayv1.diff
patch  -p1  -d vendor/brightray/vendor/libchromiumcontent/  < ../electron_vendor_libchromiumcontentv1.diff
unzip ../libchromiumcontent/libchromiumcontent.zip -d vendor/brightray/vendor/download/libchromiumcontent/
unzip ../libchromiumcontent/libchromiumcontent-static.zip -d vendor/brightray/vendor/download/libchromiumcontent/
script/bootstrap.py -v --clang_dir=/usr
script/build.py -c R
script/create-dist.py -c R
#Building VSCODE
echo "Building VSCODE"
git clone https://github.com/microsoft/vscode
cd vscode/
###v1.7.0
git checkout 1.7.0
patch -p1  < ../vscodev1.diff
scripts/npm.sh install --arch=x64
patch -p1  < ../vscode.pty.cc.diff
gmake -C node_modules/pty.js/build/

scripts/npm.sh install --arch=x64
./node_modules/.bin/gulp compile
# If the above command fails in monaco, run,
#./node_modules/.bin/gulp watch
#./node_modules/.bin/gulp compile
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BUILDROOT/electron/dist/ 
../electron/dist/electron .

