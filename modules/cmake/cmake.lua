--
-- xcode_common.lua
-- Functions to generate the different sections of an Xcode project.
-- Copyright (c) 2009-2015 Jason Perkins and the Premake project
--

	local b = build

	b.modules.cmake = {}

	local cmake = b.modules.cmake
	

---
-- Attempts to run cmake with the specified options as described by the project object
---

	function cmake.generate( prj, environment, configuration, installDir )
    -- build up the build command
  	local cmd = "cmake"
    cmd = cmd .. ' -G"Visual Studio 15 2017 Win64"' 
  	if prj.naming == "standard " then
    	cmd = cmd .. ' -DCMAKE_DEBUG_POSTFIX="d"'
  	end

    cmd = cmd .. ' -DCMAKE_INSTALL_PREFIX="' .. installDir .. '"';
    cmd = cmd .. ' -DCMAKE_INSTALL_MESSAGE="LAZY"'

  	if prj.build_defines ~= nil then
    	for key, value in pairs( prj.build_defines ) do
      		cmd = cmd .. ' -D' .. value
    	end
  	end

  	cmd = cmd .. " " .. prj.path .. " >> output_file.txt"

  	-- Execute generation script
  	os.execute( cmd )
	end