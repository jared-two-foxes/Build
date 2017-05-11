/**
 * \file   premake.c
 * \brief  Program entry point.
 * \author Copyright (c) 2002-2015 Jason Perkins and the Premake project
 */

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "build.h"

#if PLATFORM_MACOSX
#include <CoreFoundation/CFBundle.h>
#endif

#if PLATFORM_BSD
#include <sys/types.h>
#include <sys/sysctl.h>
#endif

#define ERROR_MESSAGE  "Error: %s\n"


static void build_premake_path( lua_State* L );
static int process_arguments( lua_State* L, int argc, const char** argv );
static int run_premake_main( lua_State* L, const char* script );


/* A search path for script files */
const char* scripts_path = NULL;

/**
 * Initialize the Premake Lua environment.
 */
int premake_init(lua_State* L)
{
	const char* value;

//	luaL_register(L, "criteria", criteria_functions);
//	luaL_register(L, "debug",    debug_functions);
//	luaL_register(L, "path",     path_functions);
//	luaL_register(L, "os",       os_functions);
//	luaL_register(L, "string",   string_functions);
//	luaL_register(L, "buffered", buffered_functions);
//
//#ifdef PREMAKE_CURL
//	luaL_register(L, "http",     http_functions);
//#endif
//
//#ifdef PREMAKE_COMPRESSION
//	luaL_register(L, "zip",     zip_functions);
//#endif

	/* push the application metadata */
	lua_pushstring(L, LUA_COPYRIGHT);
	lua_setglobal(L, "_COPYRIGHT");

	lua_pushstring(L, BUILD_VERSION);
	lua_setglobal(L, "_BUILD_VERSION");

	lua_pushstring(L, BUILD_COPYRIGHT);
	lua_setglobal(L, "_BUILD_COPYRIGHT");

	lua_pushstring(L, BUILD_PROJECT_URL);
	lua_setglobal(L, "_BUILD_URL");

	/* set the OS platform variable */
	lua_pushstring(L, PLATFORM_STRING);
	lua_setglobal(L, "_TARGET_OS");

	/* find the user's home directory */
	value = getenv("HOME");
	if (!value) value = getenv("USERPROFILE");
	if (!value) value = "~";
	lua_pushstring(L, value);
	lua_setglobal(L, "_USER_HOME_DIR");

	/* publish the initial working directory */
	//os_getcwd(L);
	//lua_setglobal(L, "_WORKING_DIR");

	/* start the premake namespace */
	lua_newtable(L);
	lua_setglobal(L, "premake");

	return OKAY;
}



int build_execute(lua_State* L, int argc, const char** argv, const char* script)
{
	int iErrFunc;

	// /* push the absolute path to the Premake executable */
	// lua_pushcfunction(L, path_getabsolute);
	// premake_locate_executable(L, argv[0]);
	// lua_call(L, 1, 1);
	// lua_setglobal(L, "_PREMAKE_COMMAND");

	/* Parse the command line arguments */
	if ( process_arguments( L, argc, argv ) != OKAY ) {
		return !OKAY;
	}

	// /* Use --scripts and PREMAKE_PATH to populate premake.path */
	// build_premake_path(L);

	/* Find and run the main Premake bootstrapping script */
	if ( run_premake_main( L, script ) != OKAY ) {
		printf( ERROR_MESSAGE, lua_tostring( L, -1 ) );
		return !OKAY;
	}

	/* in debug mode, show full traceback on all errors */
#if defined(NDEBUG)
	iErrFunc = 0;
#else
	lua_getglobal( L, "debug" );
	lua_getfield( L, -1, "traceback" );
	iErrFunc = -2;
#endif

	/* and call the main entry point */
	lua_getglobal( L, "_premake_main" );
	if ( lua_pcall( L, 0, 1, iErrFunc ) != OKAY) {
		printf( ERROR_MESSAGE, lua_tostring( L, -1 ) );
		return !OKAY;
	}
	else {
		return (int)lua_tonumber( L, -1 );
	}
}



/**
 * Checks one or more of the standard script search locations to locate the
 * specified file. If found, returns the discovered path to the script on
 * the top of the Lua stack.
 */
int premake_test_file(lua_State* L, const char* filename, int searchMask)
{
	if ( searchMask & TEST_LOCAL ) {
		if ( do_isfile( L, filename ) ) {
			lua_pushcfunction( L, path_getabsolute );
			lua_pushstring( L, filename );
			lua_call( L, 1, 1 );
			return OKAY;
		}
	}

	if ( scripts_path && ( searchMask & TEST_SCRIPTS ) ) {
		if ( do_locate( L, filename, scripts_path ) ) return OKAY;
	}

	if ( searchMask & TEST_PATH ) {
		const char* path = getenv( "PREMAKE_PATH" );
		if ( path && do_locate( L, filename, path ) ) return OKAY;
	}

	//#if !defined(PREMAKE_NO_BUILTIN_SCRIPTS)
	//if ( ( searchMask & TEST_EMBEDDED ) != 0 ) {
	//	/* Try to locate a record matching the filename */
	//	if ( premake_find_embedded_script( filename ) != NULL ) {
	//		lua_pushstring( L, "$/" );
	//		lua_pushstring( L, filename );
	//		lua_concat( L, 2 );
	//		return OKAY;
	//	}
	//}
	//#endif

	return !OKAY;
}



/**
 * Copy all command line arguments into the script-side _ARGV global, and
 * check for the presence of a /scripts=<path> argument to help locate
 * the manifest if needed.
 * \returns OKAY if successful.
 */
static int process_arguments( lua_State* L, int argc, const char** argv )
{
	int i;

	/* Copy all arguments in the _ARGV global */
	lua_newtable( L );
	for (i = 1; i < argc; ++i)
	{
		lua_pushstring( L, argv[i] );
		lua_rawseti( L, -2, lua_objlen( L, -2 ) + 1 );

		/* The /scripts option gets picked up here; used later to find the
		 * manifest and scripts later if necessary */
		//if ( strncmp(argv[i], "/scripts=", 9) == 0 )
		//{
		//	argv[i] = set_scripts_path( argv[i] + 9 );
		//}
		//else if ( strncmp( argv[i], "--scripts=", 10 ) == 0 )
		//{
		//	argv[i] = set_scripts_path( argv[i] + 10 );
		//}
	}
	lua_setglobal( L, "_ARGV" );

	return OKAY;
}



/**
 * Find and run the main Premake bootstrapping script. The loading of the
 * bootstrap and the other core scripts use a limited set of search paths
 * to avoid mismatches between the native host code and the scripts
 * themselves.
 */
static int run_premake_main( lua_State* L, const char* script )
{
	/* Release builds want to load the embedded scripts, with --scripts
	 * argument allowed as an override. Debug builds will look at the
	 * local file system first, then fall back to embedded. */
#if defined(NDEBUG)
	int z = premake_test_file( L, script,
		TEST_SCRIPTS | TEST_EMBEDDED );
#else
	int z = premake_test_file( L, script,
		TEST_LOCAL | TEST_SCRIPTS | TEST_PATH | TEST_EMBEDDED );
#endif

	/* If no embedded script can be found, release builds will then
	 * try to fall back to the local file system, just in case */
#if defined(NDEBUG)
	if (z != OKAY) {
		z = premake_test_file( L, script, TEST_LOCAL | TEST_PATH );
	}
#endif

	if ( z == OKAY ) {
		z = luaL_dofile( L, lua_tostring( L, -1 ) );
	}
	return z;
}



/**
 * Locate a file in the embedded script index. If found, returns the
 * contents of the file's script.
 */

// const buildin_mapping* premake_find_embedded_script( const char* filename )
// {
// #if !defined( PREMAKE_NO_BUILTIN_SCRIPTS )
// 	int i;
// 	for ( i = 0; builtin_scripts[i].name != NULL; ++i ) {
// 		if ( strcmp(builtin_scripts[i].name, filename) == 0 ) {
// 			return builtin_scripts + i;
// 		}
// 	}
// #endif
// 	return NULL;
// }



/**
 * Load a script that was previously embedded into the executable. If
 * successful, a function containing the new script chunk is pushed to
 * the stack, just like luaL_loadfile would do had the chunk been loaded
 * from a file.
 */

// int premake_load_embedded_script( lua_State* L, const char* filename )
// {
// #if !defined( NDEBUG )
// 	static int warned = 0;
// #endif

// 	const buildin_mapping* chunk = premake_find_embedded_script( filename );
// 	if ( chunk == NULL ) {
// 		return !OKAY;
// 	}

// 	/* Debug builds probably want to be loading scripts from the disk */
// #if !defined( NDEBUG )
// 	if ( !warned ) {
// 		warned = 1;
// 		printf( "** warning: using embedded script '%s'; use /scripts argument to load from files\n", filename );
// 	}
// #endif

// 	/* "Fully qualify" the filename by turning it into the form $/filename */
// 	lua_pushstring( L, "$/" );
// 	lua_pushstring( L, filename );
// 	lua_concat( L, 2 );

// 	/* Load the chunk */
// 	return luaL_loadbuffer(L, (const char*)chunk->bytecode, chunk->length, filename);
// }
