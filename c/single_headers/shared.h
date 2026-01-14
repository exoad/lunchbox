/*
Copyright (c) 2026, Jiaming Meng (jackm@exoad.net)

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#ifndef SHARED_H
#define SHARED_H

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <math.h>

typedef int32_t Int32;
typedef int64_t Int64;
typedef uint32_t UInt32;
typedef uint64_t UInt64;
typedef char Int8;
typedef uint8_t UInt8;
typedef uintptr_t UPtr;
typedef size_t Size;
typedef float Float32;
typedef double Float64;
typedef int16_t Int16;
typedef uint16_t UInt16;
typedef void Void;
typedef const Int8* CharSeq;
typedef FILE CFile;
typedef bool Bool;
typedef Void* Any;

#if defined(_WIN32) || defined(_WIN64)
    #if defined(build)
        #define api __declspec(dllexport)
    #elif defined(use)
        #define api __declspec(dllimport)
    #else
        #define api
    #endif
#else
    #define api
#endif

#ifdef __cplusplus
    #define linkage extern "C"
#else
    #define linkage extern
#endif

#define expose linkage api

#ifdef __GNUC__
#define pure       __attribute__((pure))
#define hot        __attribute__((hot))
#define flatten    __attribute__((flatten))
#define constfx    __attribute__((const))
#define never      __attribute__((noreturn))
#define deprecated __attribute__((deprecated))
#define unused     __attribute__((unused))
#define packed     __attribute__((packed))
#else
#define pure
#define hot
#define flatten
#define constfx
#define never
#define deprecated
#define unused
#define packed
#endif

#define null NULL
#define simple static inline
#define use(x) (Void) (x)
#define PI 3.14159265358979323846f
#define sizeOf sizeof

#endif
