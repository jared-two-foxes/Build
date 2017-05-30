--
-- raw.lua
-- 
-- Copyright (c) 2009-2015 Jason Perkins and the Premake project
--

	local b = build
	local raw = b.raw
	


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
