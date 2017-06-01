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
		trigger     = "boost",
		shortname   = "Boost.Build",
		description = "Generate's Boost.Build based project files",


		onGenerate = function( wksp, toolset, installDir  )
			b.modules.boost.generate( wksp, toolset, installDir )
		end,

	}


--
-- Decide when the full module should be loaded.
--

	return function(cfg)
		return (_ACTION == "boost")
	end
