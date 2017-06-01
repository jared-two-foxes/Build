--
-- xcode_common.lua
-- Functions to generate the different sections of an Xcode project.
-- Copyright (c) 2009-2015 Jason Perkins and the Premake project
--

	local b = build

	b.modules.boost = {}

	local boost = b.modules.boost
	
	boost.toolsetNames = {
		vs2017 = "msvc-14.1",
		vs2015 = "msvc-14.0"
	}

---
-- Attempts to run cmake with the specified options as described by the project object
---

	function boost.generate( wksp, toolset, installDir )
	    local p = os.getcwd()
	    os.chdir( wksp.path )

	    local cmd = "b2 "
	    cmd = cmd .. "toolset=" .. boost.toolsetNames[ toolset ]
	    cmd = cmd .. " --variant=debug"
	    cmd = cmd .. " address-model=64"
	    cmd = cmd .. " --architecture=ia64"
	    cmd = cmd .. " --threading=multi" 
	    cmd = cmd .. " --link=static"
	    cmd = cmd .. " --prefix=" .. installDir
	    cmd = cmd .. " -j8 install"
	    
	    os.execute( cmd .. " >> generate.log" )

	    os.chdir( p )
	end
