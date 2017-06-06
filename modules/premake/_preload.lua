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


		onGenerate = function( wksp, toolset, installDir  )
			b.modules.premake.generate( wksp, toolset, installDir )
		end,

		onCompile = function( wksp, toolset, configuration )
			b.msvc.compile( wksp, configuration )
		end,

		onInstall = function( wksp, installDir, configuration )

			if installDir ~= nil then
				b.raw.copyFilesWithDirectory( 
					path.join( wksp.path, "Source" ), 
					path.join( installDir, "include" ),
					b.raw.headers )
	
				b.raw.copyFiles( 
					path.join( _WORKING_DIR, "_build", wksp.name ), 
					path.join( installDir, "lib" ), 
					b.raw.libraries )

				b.raw.copyFiles( 
					path.join( _WORKING_DIR, "_build", wksp.name ), 
					path.join( installDir, "bin" ), 
					b.raw.binaries )
			end
		end,
	}


--
-- Decide when the full module should be loaded.
--

	return function(cfg)
		return (_ACTION == "premake5")
	end
