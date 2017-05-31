--
-- raw.lua
-- 
-- Copyright (c) 2009-2015 Jason Perkins and the Premake project
--

	local b = build
	local raw = b.raw
	


  raw.headers = { "**.h", "**.hpp" }

  raw.library = { "**.lib", "**.pdb" }

  raw.binaries = { "**.exe", "**.dll" }


---
--
---

  function raw.copyFiles( src_dir, dst_dir, patterns )
    for _, pattern in pairs( patterns ) do
      local files_found = os.matchfiles( path.join( src_dir, pattern ) )
      if files_found ~= nil then 
        for _, filename in pairs( files_found ) do
          local relative = path.getrelative( src_dir, filename )
          local dst_file = path.join( dst_dir, relative )
          local dst_file_dir = path.getdirectory( dst_file )
          if not os.isdir( dst_file_dir ) then       -- Check if the directory exists.
            local ok, err = os.mkdir( dst_file_dir ) -- Attempt to make the directory if it doesnt.
            if not ok then                                             -- Check that the directory creation succeeded.
              print( "Error: " .. err )
            end
          end
          local ok, err = os.copyfile( filename, dst_file ) -- Copy the file.
          if not ok then
            print( err )
          end
        end
      end
    end
  end


---
--
---

  function raw.install( sourceDir, installDir, configuration ) 
    -- Headers
    copyFiles(
      sourceDir, 
      path.join( installDir, "include" ), 
      headers )

    -- Copy Library files
    copyFiles( sourceDir, path.join( installDir, "lib" ), libraries )

    -- Copy Binaries files
    copyFiles( sourceDir, path.join( installDir, "bin" ), binaries )
  end



