--
-- _raw.lua
-- Define the makefile action(s).
-- Copyright (c) 2002-2015 Jason Perkins and the Premake project
--

	local b = build
	b.raw = {}

---
-- 
---

	newaction {
		trigger         = "raw",
		shortname       = "",
		description     = "",

		onInstall = function( project, installDir, configuration )
			b.raw.install( project.path, installDir, configuration )
		end,

	}
