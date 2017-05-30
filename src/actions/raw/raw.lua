--
-- raw.lua
-- 
-- Copyright (c) 2009-2015 Jason Perkins and the Premake project
--

	local b = build
	local raw = b.raw
	

---
-- Attempts to run cmake with the specified options as described by the project object
---

	function raw.install( project, installDir, configuration )
      copy_files( 
        project.path, 
        path.join( installDir, "include" ), 
        { "**.h", "**.hpp" } )

      -- Copy Library files
      copy_files( project.path, path.join( installDir, "lib" ), { "**.lib", "**.pdb" } )

      -- Copy Binaries files
      copy_files( project.path, path.join( installDir, "lib" ), { "**.dll" } ) -- Dont copy the exe's?
	end
