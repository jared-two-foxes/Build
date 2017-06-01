---
-- cmake/_preload.lua
-- Define the premake actions.
-- Copyright (c) 2009-2015 Jason Perkins and the Premake project
---

	local b = build


--
-- Register the premake exporters.
--

	newaction {
		trigger     = "cmake",
		shortname   = "CMake",
		description = "Generate's cmake based project files",


		-- Workspace and project generation logic


		onGenerate = function( project, toolset, installDir  )
			b.modules.cmake.generate( project, toolset, installDir )
		end,

		onCompile = function( project, toolset, config )
			b.msvc.compile( project, config )
		end,

		onInstall = function( project, installDir, config )
			-- todo;
			--		this is actually a little broken as INSTALL.vcxproj is going to
			-- 		install the files into the location defined during the generation 
			--		step.
			b.msvc.compile( project, config, "INSTALL.vcxproj" )
		end,
	}


--
-- Decide when the full module should be loaded.
--

	return function(cfg)
		return (_ACTION == "cmake")
	end
   