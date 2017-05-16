/**
 * \file   premake_main.c
 * \brief  Program entry point.
 * \author Copyright (c) 2002-2013 Jason Perkins and the Premake project
 */

#include "build.h"

int 
main( int argc, const char** argv )
{
	lua_State* L;
	int z;

	L = luaL_newstate();
	luaL_openlibs( L );

	z = build_init( L );
	if (z == OKAY) {
		z = build_execute( L, argc, argv, "src/_build_main.lua" );
	}

	lua_close( L );
	return z;
}
