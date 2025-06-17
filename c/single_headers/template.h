/*
Copyright (c) 2025, Jiaming Meng

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

/*

"Naming Scheme"

    Functions:
        All functions and macros must use camelCase where possible; however, it is allowed
        to add a prefix word followed by an underscore and the function name in camelCase.
        The latter should be used as a last resort when not specifying something like a
        library prefix would make things too ambiguous. Additionally, functions are not
        allowed to start nor end with underscores because it may be interpreted as a
        visibility modifier, when such thing is not really possible.

        Ok:
            - main
            - add2Numbers
            - myFunction
            - anotherReallyLongFunctionName
            - library_myFunction
            - clib_function

        Bad:
            - _fx
            - _
            - MyFunction
            - this_function_is_not_a_library
            - fx_

    Variables:
        Variables are to be named as short and concise as possible but fitting within a
        meaningful english word. For example, it would be innapropriate to rename "rect"
        to just "r", but it is fine to rename "rectangle" to "rect". Additionally, they
        use camelCase but with the exception that underscores ARE NEVER ALLOWED unless it
        is a constant. A constant variable should be all uppercase and each word separated
        with an underscore. However, underscores cannot precede and succeed the name.

        Ok:
            - x
            - someVariable
            - MY_CONSTANT

        Bad:
            - _smallVariable
            - x_
            - ThiS_IsntAcOnstant
            - _

    Types:
        Types should follow a PascalCase formatting and underscores are never allowed. If
        a library name or other prefix word is required, it is just advised to stick that
        word infront of the type name and following PascalCase.

        Ok:
            - MyType
            - Vector2
            - Vec2
            - I32
            - CFloat

        Bad:
            - myType
            - vec2
            - i32
            - _
            - My_Favorite_Type

    Macros:
        Macros depend on the context. A macro that redefines a type (not a function)
        should follow standard naming schemes for a type. On the other hand, if the function
        is either redefining another function or acts like a function-like macro should
        follow the functions naming scheme. However, the exception are for things like FLAG
        macro should follow the naming scheme used for a constant with the exception that
        if they are an include guard, they can have underscores preceding and succeeding.

*/

#ifndef __JM_TEMPLATE_DEFS_H__
#define __JM_TEMPLATE_DEFS_H__

#include <assert.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>

typedef unsigned char uint8;
typedef unsigned int uint;
typedef long long int64;
typedef uintptr_t uintptr;
typedef size_t usize;
typedef uint32_t uint32;

// shorter hand formats
typedef int32_t I32;
typedef long L32;
typedef int64_t I64;
typedef int I32;
typedef uint32_t U32;
typedef uint64_t U64;
typedef char I8; // this might ignore the existence of signed char
typedef int8_t S8; // signed char :)
typedef uint8_t U8;
typedef uintptr_t UPtr;
typedef size_t Sz;
typedef bool Bool;
typedef float F32;
typedef double F64;
typedef int16_t I16;
typedef uint16_t U16;
typedef void U0;
typedef void Void;


#ifdef JM_REDEFINE_SDL_TYPES

typedef SDL_FRect Rect;
typedef SDL_Event SDLEvent;
typedef SDL_Surface SDLSurface;
typedef SDL_Window SDLWindow;
typedef SDLRenderer SDLRenderer;
#define newRect(x, y, w, h) ((SDL_FRect) {x, y, w, h})

// redefine some functions and stuffs so they are not so cluttered in their naming
#define setDrawColor SDL_SetRenderDrawColor
#define clearRender SDL_RenderClear
#define drawRect SDL_RenderRect
#define flushRender SDL_RenderFlush
#define updateWindowSurface SDL_UpdateWindowSurface
#define sdl_delay SDL_Delay


#endif

#define null (U0*) 0

#define ensure(ptr)                                                           \
        if ((ptr) == NULL)                                                    \
        {                                                                     \
                fprintf(stderr, "NULL_PTR_ERROR: '%s' is NULL at %s:%d in %s()\n", \
                         #ptr, __FILE__, __LINE__, __func__);                 \
                exit(EXIT_FAILURE);                                           \
        }

// Printf but with a new line at the end
#define println(format, ...) printf(format "\n", ##__VA_ARGS__)

// Prints the target message to stderr with debug information including file name, line number, and function name
#define printerr(fmt, ...) \
        fprintf(stderr, "\n%s:%d :: %s " fmt "\n", __FILE__, __LINE__, __func__, ##__VA_ARGS__)

#endif
