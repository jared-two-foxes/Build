--
-- xcode_common.lua
-- Functions to generate the different sections of an Xcode project.
-- Copyright (c) 2009-2015 Jason Perkins and the Premake project
--

	local b = build

	b.modules.premake = {}

	local premake = b.modules.premake
	

---
-- Attempts to run cmake with the specified options as described by the project object
---

	function premake.generate( wksp, toolset, configuration )
		local buildCmd = "premake5" 
		buildCmd = buildCmd .. " --file=" .. wksp.path .."/premake5.lua"
		buildCmd = buildCmd .. " --outdir=" .. os.getcwd()
		buildCmd = buildCmd .. " " .. toolset 

		print( os.getcwd() )
		print( buildCmd )
  		os.execute( buildCmd .. ">> generate.log " )
	end
