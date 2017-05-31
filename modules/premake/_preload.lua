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
			b.msvc.compile( project, configuration )
		end,

		onInstall = function( project, installDir, configuration )
			if installDir ~= nil then
				b.raw.copyFiles( 
					path.join( project.path, "Source" ), 
					path.join( installDir, "install", project.name ),
					b.raw.headers )
			end

			local p = project.name
			if installDir ~= nil then
				p = installDir 
			end

			b.raw.copyFiles( 
				path.join( project.path, "Projects", project.name ), 
				path.join( p, "lib" ), 
				b.raw.libraries )

			b.raw.copyFiles( 
				path.join( project.path, "Projects", project.name ), 
				path.join( p, "bin" ), 
				b.raw.binaries )
		end,
	}


--
-- Decide when the full module should be loaded.
--

	return function(cfg)
		return (_ACTION == "premake5")
	end
