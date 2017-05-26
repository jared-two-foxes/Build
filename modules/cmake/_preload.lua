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


		onGenerate = function( project, environment, configuration, installDir  )
			b.modules.cmake.generate( project, environment, configuration, installDir )
		end,

		onCompile = function( project, environment, configuration )
			b.modules.cmake.compile( project, environment, configuration )
		end,

		onInstall = function( project, installDir, configuration )
			b.modules.cmake.install( project, environment, configuration )
		end,
	}


--
-- Decide when the full module should be loaded.
--

	return function(cfg)
		return (_ACTION == "cmake")
	end
