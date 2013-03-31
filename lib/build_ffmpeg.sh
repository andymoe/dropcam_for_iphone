#!/bin/bash

ROOT_PATH=`pwd`/`dirname "$0"`
LIB_PATH=$ROOT_PATH/ffmpeg_build

if [ ! -s $ROOT_PATH/ffmpeg/libswscale ] ; then
	ln -sf ../libswscale/ $ROOT_PATH/ffmpeg/libswscale
fi

mkdir -p $LIB_PATH/{i386,armv7,armv7s}

PATH=$PATH:$ROOT_PATH

COMMON_PARAMS="--disable-doc --disable-ffplay --disable-ffserver \
--disable-encoders --disable-decoders --disable-hwaccels \
--disable-muxers --disable-demuxers --disable-parsers --disable-bsfs \
--disable-protocols --disable-indevs --disable-outdevs --disable-devices \
--disable-filters --disable-network --disable-zlib --disable-bzlib \
--enable-decoder=h264 \
--enable-demuxer=h264 \
--enable-parser=h264"

# Note - to disable optimizations (for debugging, etc.), add the following:
# --enable-decoder=h263 --enable-decoder=svq3 --disable-optimizations"

cd $LIB_PATH/armv7
../../ffmpeg/configure --disable-doc --disable-ffmpeg --disable-ffplay --disable-ffserver --enable-cross-compile --arch=arm \
--target-os=darwin --cc=clang --as='gas-preprocessor/gas-preprocessor.pl /usr/bin/clang' \
--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk \
--cpu=cortex-a8 --extra-cflags='-arch armv7' \
--extra-ldflags='-arch armv7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk' \
--enable-pic --enable-decoder=rawvideo --disable-asm
$COMMON_PARAMS
make

cd $LIB_PATH/armv7s
../../ffmpeg/configure --disable-doc --disable-ffmpeg --disable-ffplay --disable-ffserver --enable-cross-compile --arch=arm \
--target-os=darwin --cc=clang --as='gas-preprocessor/gas-preprocessor.pl /usr/bin/clang' \
--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk \
--cpu=cortex-a8 --extra-cflags='-arch armv7s' \
--extra-ldflags='-arch armv7s -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk' \
--enable-pic --enable-decoder=rawvideo --disable-asm
$COMMON_PARAMS
make

# OLD i386 build stuff (broken)
# ../../ffmpeg/configure --enable-cross-compile --arch=i386 --target-os=darwin \
# --cc=/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/clang \
# --sysroot=/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneOS6.1.sdk \
# --extra-cflags='-arch i386' --extra-ldflags='-arch i386' --enable-pic --disable-mmx --disable-mmx2 \
# $COMMON_PARAMS
# 
# make

# new i386 build stuff (also, broken)
# cd $LIB_PATH/i386
# SIMULATOR_CONFIG=""
# 
# cd $LIB_PATH/i386
# ../../ffmpeg/configure --disable-ffmpeg --disable-ffplay --disable-ffserver --enable-cross-compile --arch=i386 \
# --target-os=darwin --cc=clang --as='gas-preprocessor/gas-preprocessor.pl /usr/bin/clang' \
# --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk \
# --cpu=cortex-a8 --extra-cflags='-arch i386' \
# --extra-ldflags='-arch i386 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk' \
# --enable-pic --enable-decoder=rawvideo --disable-asm
# make

cd $LIB_PATH

# for l in `echo -ne "libavcodec\nlibavdevice\nlibavformat\nlibavutil\nlibswscale"`; do
#   lipo -create "i386/$l/$l.a" "iphone3gs/$l/$l.a" "iphone3g/$l/$l.a" -output "$l.a";
# done

for l in `echo -ne "libavcodec\nlibavdevice\nlibavformat\nlibavutil\nlibswscale"`; do
  lipo -create "armv7/$l/$l.a" "armv7s/$l/$l.a" -output "$l.a";
done

