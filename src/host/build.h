/**
 * \file   premake.h
 * \brief  Program-wide constants and definitions.
 * \author Copyright (c) 2002-2015 Jason Perkins and the Premake project
 */

#define lua_c
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#define BUILD_VERSION        "5.0.0-dev"
#define BUILD_COPYRIGHT      "Copyright (C) 2017 Jared Watt and the Premake Project"
#define BUILD_PROJECT_URL    "https://github.com/premake/premake-core/wiki"

/* Identify the current platform I'm not sure how to reliably detect
 * Windows but since it is the most common I use it as the default */
#if defined(__linux__)
#define PLATFORM_LINUX    (1)
#define PLATFORM_STRING   "linux"
#elif defined(__FreeBSD__) || defined(__FreeBSD_kernel__) || defined(__NetBSD__) || defined(__OpenBSD__) || defined(__DragonFly__)
#define PLATFORM_BSD      (1)
#define PLATFORM_STRING   "bsd"
#elif defined(__APPLE__) && defined(__MACH__)
#define PLATFORM_MACOSX   (1)
#define PLATFORM_STRING   "macosx"
#elif defined(__sun__) && defined(__svr4__)
#define PLATFORM_SOLARIS  (1)
#define PLATFORM_STRING   "solaris"
#elif defined(__HAIKU__)
#define PLATFORM_HAIKU    (1)
#define PLATFORM_STRING   "haiku"
#elif defined (_AIX)
#define PLATFORM_AIX  (1)
#define PLATFORM_STRING  "aix"
#elif defined (__GNU__)
#define PLATFORM_HURD  (1)
#define PLATFORM_STRING  "hurd"
#else
#define PLATFORM_WINDOWS  (1)
#define PLATFORM_STRING   "windows"
#endif

#define PLATFORM_POSIX  (PLATFORM_LINUX || PLATFORM_BSD || PLATFORM_MACOSX || PLATFORM_SOLARIS)


/* Pull in platform-specific headers required by built-in functions */
#if PLATFORM_WINDOWS
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdlib.h>
#else
#include <unistd.h>
#endif


/* Fill in any missing bits */
#ifndef PATH_MAX
#define PATH_MAX   (4096)
#endif


/* A success return code */
#define OKAY   (0)


/* Bitmasks for the different script file search locations */
#define TEST_LOCAL     (0x01)
#define TEST_SCRIPTS   (0x02)
#define TEST_PATH      (0x04)
#define TEST_EMBEDDED  (0x08)


/* If a /scripts argument is present, its value */
extern const char* scripts_path;


/* Bootstrapping helper functions */
int do_chdir(lua_State* L, const char* path);
unsigned long do_hash(const char* str, int seed);
void do_getabsolute(char* result, const char* value, const char* relative_to);
int do_getcwd(char* buffer, size_t size);
int do_isabsolute(const char* path);
int do_isfile(lua_State* L, const char* filename);
int do_locate(lua_State* L, const char* filename, const char* path);
void do_normalize(lua_State* L, char* buffer, const char* path);
int do_pathsearch(lua_State* L, const char* filename, const char* path);
void do_translate(char* value, const char sep);


#ifdef _MSC_VER
 #ifndef snprintf
  #define snprintf _snprintf
 #endif
#endif

/* Engine interface */

typedef struct
{
	const char*          name;
	const unsigned char* bytecode;
	size_t               length;
} buildin_mapping;

extern const buildin_mapping builtin_scripts[];


int build_init(lua_State* L);
int build_execute(lua_State* L, int argc, const char** argv, const char* script);
int build_load_embedded_script(lua_State* L, const char* filename);
const buildin_mapping* build_find_embedded_script(const char* filename);

int build_locate_executable(lua_State* L, const char* argv0);
int build_test_file(lua_State* L, const char* filename, int searchMask);
