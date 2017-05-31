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

	function premake.generate( project, environment, configuration, installDir )
  		os.execute( "premake5" .. " vs2017 --file=" .. project.path .."/premake5.lua" )
	end
