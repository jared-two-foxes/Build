--
-- xcode_common.lua
-- Functions to generate the different sections of an Xcode project.
-- Copyright (c) 2009-2015 Jason Perkins and the Premake project
--

	local b = build

	b.modules.cmake = {}

	local cmake = b.modules.cmake
	
  -- todo; Assumes all builds are 64 bit..?
  cmake.toolsetNames = {
    vs2017 = "Visual Studio 15 2017 Win64",
    vs2015 = "Visual Studio 14 2015 Win64"
  }

---
-- Attempts to run cmake with the specified options as described by the project object
---

	function cmake.generate( wksp, toolset, installDir )
    -- build up the build command
  	local cmd = "cmake"

    cmd = cmd .. ' -G"' .. cmake.toolsetNames[ toolset ] .. '"' 
  	if wksp.naming == "standard " then
    	cmd = cmd .. ' -DCMAKE_DEBUG_POSTFIX="d"'
  	end

    cmd = cmd .. ' -DCMAKE_INSTALL_PREFIX="' .. installDir .. '"';
    
    cmd = cmd .. ' -DCMAKE_INSTALL_MESSAGE="LAZY"'

  	if wksp.build_defines ~= nil then
    	for key, value in pairs( wksp.build_defines ) do
      		cmd = cmd .. ' -D' .. value
    	end
  	end

  	cmd = cmd .. " " .. wksp.path

  	-- Execute generation script
  	os.execute( cmd  .. " >> generate.log" )
	end