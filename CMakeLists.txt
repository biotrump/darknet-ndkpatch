cmake_minimum_required(VERSION 3.0.0)
project(YOLO-NDK C CXX)

##
## PROJECT
## name and version
##
project(YOLO-NDK VERSION 2 LANGUAGES CXX)

message("YOLO-NDK_SOURCE_DIR = ${YOLO-NDK_SOURCE_DIR}")
message("YOLO-NDK_BINARY_DIR = ${YOLO-NDK_BINARY_DIR}")

# --------------------------------------------------
# Organize output files.  On Windows this also keeps .dll files next
# to the .exe files that need them, making tests easy to run.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${YOLO-NDK_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${YOLO-NDK_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${YOLO-NDK_BINARY_DIR}/lib)

##
## INCLUDE
##
##
#include(ExternalProject)

##
## OPTIONS
##

option(DEBUG "Compile with debugging information" OFF)

if(DEBUG)
	set(CMAKE_BUILD_TYPE "Debug")
endif()
message("***CMAKE_BUILD_TYPE = ${CMAKE_BUILD_TYPE}")

#option(JSON_BuildTests "Build the unit tests when BUILD_TESTING is enabled." ON)
#option(JSON_MultipleHeaders "Use non-amalgamated version of the library." OFF)

##
## CONFIGURATION
##


#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wno-unknown-pragmas -Wfatal-errors -fPIC")
#set(CMAKE_LD_FLAGS "${CMAKE_LD_FLAGS} -lm -pthread -fopenmp")

if("${CMAKE_BUILD_TYPE}" MATCHES "Debug")
  add_definitions(-DDEBUG)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -g -O0 -fPIC")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99 -g -O0 -fPIC -D_POSIX_C_SOURCE=200809")
else()
  add_definitions(-DARMA_NO_DEBUG)
  add_definitions(-DNDEBUG)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -O3 -fPIC")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99 -O3 -fPIC -D_POSIX_C_SOURCE=200809")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fstrict-aliasing -mfpu=neon-vfpv4 -funsafe-math-optimizations -ftree-vectorize")
endif()

option(PROFILE "Compile with profiling information" OFF)
# Profiling CFLAGS.  Turn profiling information on.
if(PROFILE)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pg")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pg")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pg")
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wno-unknown-pragmas -Wfatal-errors")
#neno opt
#openmp opt -fopenmp 
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}  -fexceptions -Dlinux -fsigned-char")

#set(CMAKE_LD_FLAGS "${CMAKE_LD_FLAGS} -lm -pthread -fopenmp")

# --------------------------------------------------
#The following libs are all built in working folders,
#so the libs' path are not in the toolchain path.
#The path is in the host path, not in the tool chain path.
#disable searching toolchain path.
# --------------------------------------------------
# switch searching path to host, not NDK or arm gnu
# If set to NEVER, then the roots in CMAKE_FIND_ROOT_PATH will be ignored
# and only the host system root will be used
# If set to ONLY, then only the roots in CMAKE_FIND_ROOT_PATH will be searched.
# host path is NOT searched.
# --------------------------------------------------
if(ANDROID_NDK OR ARM_LINUX_SYSROOT)
set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER )
set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY )
set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY )
endif()
# --------------------------------------------------
include_directories(
	${YOLO-NDK_SOURCE_DIR}
	${YOLO-NDK_SOURCE_DIR}/include
)
# --------------------------------------------------
#openMP to avoid link error : omp_xxx error!
# undefined reference to `GOMP_loop_dynamic_start
find_package(OpenMP)
if(OPENMP_FOUND)
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
	add_definitions(-DENABLE_OPENMP)
endif()
# --------------------------------------------------
if(ANDROID_NDK)
find_package (Threads REQUIRED)
endif()
# --------------------------------------------------
# --------------------------------------------------
#Cmakefilelist : some source files are not used
#file(GLOB darknet_files "src/*.c")
if(DARKNET_V2)
ADD_LIBRARY(darknet_filesV2 OBJECT
			src/gemm.c
			src/utils.c 
			src/cuda.c 
			src/deconvolutional_layer.c 
			src/convolutional_layer.c 
			src/list.c 
			src/image.c 
			src/activations.c 
			src/im2col.c 
			src/col2im.c
			src/blas.c 
			src/crop_layer.c 
			src/dropout_layer.c 
			src/maxpool_layer.c 
			src/softmax_layer.c 
			src/data.c 
			src/matrix.c 
			src/network.c 
			src/connected_layer.c 
			src/cost_layer.c 
			src/parser.c 
			src/option_list.c 
			src/detection_layer.c 
			src/route_layer.c 
			src/upsample_layer.c 
			src/box.c 
			src/normalization_layer.c 
			src/avgpool_layer.c 
			src/layer.c 
			src/local_layer.c 
			src/shortcut_layer.c 
			src/logistic_layer.c 
			src/activation_layer.c 
			src/rnn_layer.c 
			src/gru_layer.c 
			src/crnn_layer.c 
			src/demo.c 
			src/batchnorm_layer.c 
			src/region_layer.c 
			src/reorg_layer.c 
			src/tree.c  
			src/lstm_layer.c 
			src/l2norm_layer.c 
			src/yolo_layer.c
			)
endif()
# --------------------------------------------------
ADD_LIBRARY(darknet_filesV3 OBJECT
			src/gemm.c
			src/utils.c 
			src/cuda.c 
			src/deconvolutional_layer.c 
			src/convolutional_layer.c 
			src/list.c 
			src/image.c 
			src/activations.c 
			src/im2col.c 
			src/col2im.c
			src/blas.c 
			src/crop_layer.c 
			src/dropout_layer.c 
			src/maxpool_layer.c 
			src/softmax_layer.c 
			src/data.c 
			src/matrix.c 
			src/network.c 
			src/connected_layer.c 
			src/cost_layer.c 
			src/parser.c 
			src/option_list.c 
			src/detection_layer.c 
			src/route_layer.c 
			src/upsample_layer.c 
			src/box.c 
			src/normalization_layer.c 
			src/avgpool_layer.c 
			src/layer.c 
			src/local_layer.c 
			src/shortcut_layer.c 
			src/logistic_layer.c 
			src/activation_layer.c 
			src/rnn_layer.c 
			src/gru_layer.c 
			src/crnn_layer.c 
			src/demo.c 
			src/batchnorm_layer.c 
			src/region_layer.c 
			src/reorg_layer.c 
			src/tree.c  
			src/lstm_layer.c 
			src/l2norm_layer.c 
			src/yolo_layer.c
			)
# --------------------------------------------------
#yoloV3
set(DARKNET_SRC_LISTS
    $<TARGET_OBJECTS:darknet_filesV3>
)
# --------------------------------------------------
#yoloV2
#set(DARKNET_SRC_LISTS
#    $<TARGET_OBJECTS:darknet_filesV2>
#)
# --------------------------------------------------
add_library( # Sets the name of the library.
             darknetlib

             # Sets the library as a shared library.
             SHARED

             # Provides a relative path to your source file(s).
             ${DARKNET_SRC_LISTS}
             )
# --------------------------------------------------
if(JNI_ENABLED)
add_library( # Sets the name of the library.
             darknetlib-jni

             # Sets the library as a shared library.
             SHARED

             # Provides a relative path to your source file(s).
#             ${DARKNET_SRC_LISTS}
             $<TARGET_OBJECTS:darknet_filesV2>
             jni/darknetlib.c
             )

target_link_libraries(darknetlib-jni
		log
		m
		stdc++)
endif()

#
#add_dependencies(darknet darknetlib)
#example 
add_executable(darknet
	examples/art.c
	examples/cifar.c
	examples/darknet.c
	examples/lsd.c
	examples/rnn.c
	examples/super.c
#	examples/voxel.c
#	examples/attention.c
	examples/classifier.c
	examples/detector.c
#	examples/dice.c
	examples/nightmare.c
#	examples/rnn_vid.c
# 	examples/swag.c
#	examples/writing.c
	examples/captcha.c
	examples/coco.c
	examples/go.c
	examples/regressor.c
	examples/segmenter.c
	examples/tag.c
	examples/yolo.c
	)
	
target_link_libraries(darknet
	darknetlib
	log
	m
	stdc++
	)