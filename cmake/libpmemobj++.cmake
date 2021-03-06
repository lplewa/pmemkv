# Copyright 2017-2019, Intel Corporation
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in
#       the documentation and/or other materials provided with the
#       distribution.
#
#     * Neither the name of the copyright holder nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

if(PKG_CONFIG_FOUND)
# XXX uncomment when libpmemobj-cpp 1.7 is released
#	pkg_check_modules(LIBPMEMOBJ++ REQUIRED libpmemobj++>=1.7)
	pkg_check_modules(LIBPMEMOBJ++ REQUIRED libpmemobj++)
else()
	find_package(LIBPMEMOBJ++ REQUIRED libpmemobj++)
	message(STATUS "libpmemobj++ found the old way (w/o pkg-config)")
endif()

set(SAVED_CMAKE_REQUIRED_INCLUDES ${CMAKE_REQUIRED_INCLUDES})
set(SAVED_CMAKE_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS})

set(CMAKE_REQUIRED_INCLUDES ${LIBPMEMOBJ++_INCLUDE_DIRS})
set(CMAKE_REQUIRED_FLAGS "--std=c++11 -Wno-error -c")

CHECK_CXX_SOURCE_COMPILES(
	"#include <libpmemobj++/experimental/string.hpp>
	int main() {}"
	PMEM_STRING_PRESENT)

if(NOT PMEM_STRING_PRESENT)
	message(FATAL_ERROR "libpmemobj++/experimental/string.hpp not found (available in libpmemobj-cpp >= 1.6)")
endif()

CHECK_CXX_SOURCE_COMPILES(
	"#include <libpmemobj++/experimental/concurrent_hash_map.hpp>
	int main() {}"
	PMEM_CONCURRENT_HASH_MAP_PRESENT)

set(CMAKE_REQUIRED_INCLUDES ${SAVED_CMAKE_REQUIRED_INCLUDES})
set(CMAKE_REQUIRED_FLAGS ${SAVED_CMAKE_REQUIRED_FLAGS})

if(NOT PMEM_CONCURRENT_HASH_MAP_PRESENT)
	message(FATAL_ERROR "libpmemobj++/experimental/concurrent_hash_map.hpp not found (available in libpmemobj-cpp > 1.6)")
endif()

include_directories(${LIBPMEMOBJ++_INCLUDE_DIRS})
link_directories(${LIBPMEMOBJ++_LIBRARY_DIRS})
