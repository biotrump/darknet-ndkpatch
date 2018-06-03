#!/bin/bash
#使用NDK和CMake在Linux上编译Android动态库
#https://blog.csdn.net/zhuyunier/article/details/78872591
#mkdir -p build

#export ANDROID_NDK_HOME=${HOME}/aosp/NDK/android-ndk-r16
export ANDROID_NDK_HOME=${HOME}/NDK/android-ndk-r16b
pushd build
pwd
#read
rm -rf CMakeCache.txt
rm -rf CMakeFiles
rm -rf cmake_install.cmake
rm -rf Makefile
rm -rf CTestTestfile.cmake

#NDK toolchain
#clang toolchain
#NDK_CLANG=clang
echo "NDK_CLANG=${NDK_CLANG}"
if [[ -n ${NDK_CLANG} ]];then
#clang is default
ANDROID_TOOLCHAIN=clang
ANDROID_TOOLCHAIN_NAME=""
else
#gnu
TARGPLAT=arm-linux-androideabi
TOOLCHAINS=arm-linux-androideabi
TOOL_VER="4.9"
ANDROID_TOOLCHAIN=""
ANDROID_TOOLCHAIN_NAME=${TOOLCHAINS}-${TOOL_VER}
fi
echo "ANDROID_TOOLCHAIN=${ANDROID_TOOLCHAIN}"
echo "ANDROID_TOOLCHAIN_NAME=${ANDROID_TOOLCHAIN_NAME}"
#read

if [[ “$@“ =~ "-d" ]];then
        echo "----------------------------cmake debug----------------------------"
cmake -DDEBUG=ON -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake \
      -DANDROID_NDK=$ANDROID_NDK_HOME \
      -DANDROID_ABI=armeabi-v7a \
      -DANDROID_TOOLCHAIN=${ANDROID_TOOLCHAIN} \
      -DANDROID_TOOLCHAIN_NAME=${ANDROID_TOOLCHAIN_NAME} \
      -DANDROID_PLATFORM=android-21 \
      -DANDROID_STL=c++_shared \
	  ..
else
        echo "----------------------------cmake release----------------------------"
cmake -DDEBUG=NO -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake \
      -DANDROID_NDK=$ANDROID_NDK_HOME \
      -DANDROID_ABI="armeabi-v7a with NEON" \
      -DANDROID_TOOLCHAIN=${ANDROID_TOOLCHAIN} \
      -DANDROID_TOOLCHAIN_NAME=${ANDROID_TOOLCHAIN_NAME} \
      -DANDROID_PLATFORM=android-21 \
      -DANDROID_STL=c++_shared \
	  ..
fi

#make
popd
#rm -rf CMakeCache.txt
#rm -rf CMakeFiles
#rm -rf cmake_install.cmake
#rm -rf Makefile
#rm -rf CTestTestfile.cmake
