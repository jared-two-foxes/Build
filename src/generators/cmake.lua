--
-- cmake.lua
-- Functions to generate a solution file via use of cmake.
-- Copyright (c) 2016-2017 Jared Watt and the Build project
--

	local b = build

	b.cmake = {}

	local cmake = b.cmake
	cmake.trigger = "cmake"
  cmake.description = "Generates workspace files using CMake"


---
--  Create a mapping from "Build" toolset names to "CMake" toolset names.
---

  -- todo; Assumes all builds are 64 bit..?
  cmake.toolsetNames = {
    vs2017 = "Visual Studio 15 2017 Win64",
    vs2015 = "Visual Studio 14 2015 Win64"
  }


---
-- Attempts to generate solution with the specified options as described by the workspace object
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


---
--  Attempts to compile the create solution
---

  function cmake.compile( project, toolset, config )
    b.msvc.compile( project, config )
  end


---
--  Attempts to execute the install step
---

  function cmake.install( project, installDir, config )
    -- todo;
    --    this is actually a little broken as INSTALL.vcxproj is going to
    --    install the files into the location defined during the generation 
    --    step.
    b.msvc.compile( project, config, "INSTALL.vcxproj" )
  end


---
--  Assign the cmake generator to the internal generators list.
---
  
  newgenerator( cmake )