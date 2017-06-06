--
-- boost.lua
-- Functions to generate a solution file via use of the Boost.Build build system.
-- Copyright (c) 2016-2017 Jared Watt and the Build project
--

	local b = build

	b.boost = {}

	local boost = b.boost
	boost.trigger = "boost"
	boost.description = "Generates workspace files using Boost.Build"


---
--  Create a mapping from "Build" toolset names to "Boost.Build" toolset names.
---

	boost.toolsetNames = {
		vs2017 = "msvc-14.1",
		vs2015 = "msvc-14.0"
	}


---
--  Attempts to run Boost.Build using options and details passed via function parameters
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



---
--  Assign the boost generator to the internal generators list.
---
	
	newgenerator( b.boost )