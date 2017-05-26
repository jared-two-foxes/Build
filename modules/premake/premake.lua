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


---
--
---

	function premake.compile( project, environment, configuration )
      	local cmd  = "devenv " 
      	if project.solution ~= nil then
        	cmd = cmd .. project.solution .. ".sln"
      	else
        	cmd = cmd .. project.name .. ".sln"
      	end
      	local conf = " /Build " .. configuration

      	local buildCmd   = cmd .. conf
      	print( buildCmd )
      	os.execute( buildCmd ) 
      	print()
	end


---
--
---

  local function copy_files( src_dir, dst_dir, patterns )
    for _, pattern in pairs( patterns ) do
      local files_found = os.matchfiles( src_dir .. pattern )
      if files_found ~= nil then 
        for _, filename in pairs( files_found ) do
          relative = path.getrelative( src_dir, filename )
          -- if not path.isdir( dst_dir ) then        -- Check if the directory exists.
          --   local ret, err = path.mkdir( dst_dir ) -- Attempt to make the directory if it doesnt.
          --   if not ret then                        -- Check that the directory creation succeeded.
          --     print( "Error: " .. err )
          --   end
          -- end
          os.copy( filename, dst_dir .. relative )  -- Copy the file.
        end
      end
    end
  end


---
--
---

	function premake.install( project, installDir, configuration ) 
	  -- Premake doesnt support compiling and it definitely doesnt support installing, furthermore we 
      -- probably dont actually want to install unless this isn't the 'toplevel' project which is signified
      -- by installDir not being set.
      if installDir then
        -- Headers
        --copy_files_with_dir( 
        copy_files(
          project.path .. "/Source", 
          path.join( installDir, "include", project.name ), 
          { "**.h", "**.hpp" } )
      end

      -- Determine the 'root' level for install
      local p = project.path
      if installDir ~= nil then
        p = installDir 
      end

      projDir = path.join( project.path, "Projects", project.name )
      if os.isdir( projDir ) then
        -- Copy Library files
        copy_files( projDir , path.join( p, "lib" ), { "**.lib", "**.pdb" } )

        -- Copy Binaries files
        copy_files( projDir, path.join( p, "bin" ), { "**.exe", "**.dll" } )
      end
	end