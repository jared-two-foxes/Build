--
-- xcode_common.lua
-- Functions to generate the different sections of an Xcode project.
-- Copyright (c) 2009-2015 Jason Perkins and the Premake project
--

	local b = build

	b.modules.boost = {}

	local boost = b.modules.boost
	

---
-- Attempts to run cmake with the specified options as described by the project object
---

	function boost.generate( prj, environment, configuration, installDir )
	    local p = os.getcwd()
	    os.chdir( prj.path )

	    local cmd = "b2 --toolset=" .. environment .. " --variant=" .. configuration .. " address-model=64 --architecture=ia64 --threading=multi --link=static --prefix=" .. installDir .. " -j8 install"
	    os.execute( cmd .. " >> output.txt" )

	    os.chdir( p )
	end
