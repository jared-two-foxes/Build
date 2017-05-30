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
		trigger     = "premake5",
		shortname   = "Premake",
		description = "Generate's cmake project",


		-- Workspace and project generation logic


		onGenerate = function( project, environment, configuration, installDir  )
			b.modules.premake.generate( project, environment, configuration, installDir )
		end,

		onCompile = function( project, environment, configuration )
			b.modules.premake.compile( project, environment, configuration )
		end,

		onInstall = function( project, installDir, configuration )
			b.modules.premake.install( project, environment, configuration )
		end,
	}


--
-- Decide when the full module should be loaded.
--

	return function(cfg)
		return (_ACTION == "premake5")
	end
