--
-- premake.lua
-- Functions to generate solution files based upon the premake build system.
-- Copyright (c) 2016-2017 Jared Watt and the Build project
--

	local b = build

	b.premake = {}

	local premake = b.premake
	premake.trigger = "premake5"
	premake.description = "Generates workspace files using premake5"
	

---
--  Attempt to create a solution by running premake.
---

	function premake.generate( wksp, toolset, configuration )
		local buildCmd = "premake5" 
		buildCmd = buildCmd .. " --file=" .. wksp.path .."/premake5.lua"
		buildCmd = buildCmd .. " --outdir=" .. os.getcwd()
		buildCmd = buildCmd .. " " .. toolset 

  		os.execute( buildCmd .. ">> generate.log" )
	end


---
--  Attempt to compile the workspace.
---
	function premake.compile( wksp, toolset, configuration )
		b.msvc.compile( wksp, configuration )
	end


---
--  Attempt to install generated files to a useable location.
---

	function premake.install( wksp, installDir, configuration )
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
	end



---
--  Assign the premake generator to the internal generators list.
---
  
  newgenerator( premake )