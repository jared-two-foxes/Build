--
-- raw.lua
-- 
-- Copyright (c) 2009-2015 Jason Perkins and the Premake project
--

	local b = build

  b.raw = {}
  
	local raw = b.raw
	raw.trigger = "raw"
  raw.description = "Fallback generator for frameworks that do not require any form of solution generation"


---
--
---

  raw.headers = { "**.h", "**.hpp" }
  raw.libraries = { "**.lib", "**.pdb" }
  raw.binaries = { "**.exe", "**.dll" }


---
--
---

  function raw.copyFiles( src_dir, dst_dir, patterns )
    for _, pattern in pairs( patterns ) do
      local files_found = os.matchfiles( path.join( src_dir, pattern ) )
      if files_found ~= nil then 
        for _, filename in pairs( files_found ) do
          local relative = path.getname( filename )
          local dst_file = path.join( dst_dir, relative )
          local dst_file_dir = path.getdirectory( dst_file )
          if not os.isdir( dst_file_dir ) then       -- Check if the directory exists.
            local ok, err = os.mkdir( dst_file_dir ) -- Attempt to make the directory if it doesnt.
            if not ok then                           -- Check that the directory creation succeeded.
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

  function raw.copyFilesWithDirectory( src_dir, dst_dir, patterns )
    for _, pattern in pairs( patterns ) do
      local files_found = os.matchfiles( path.join( src_dir, pattern ) )
      if files_found ~= nil then 
        for _, filename in pairs( files_found ) do
          local relative = path.getrelative( src_dir, filename )
          local dst_file = path.join( dst_dir, relative )
          local dst_file_dir = path.getdirectory( dst_file )
          if not os.isdir( dst_file_dir ) then       -- Check if the directory exists.
            local ok, err = os.mkdir( dst_file_dir ) -- Attempt to make the directory if it doesnt.
            if not ok then                           -- Check that the directory creation succeeded.
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

  function raw.install( wksp, installDir, configuration ) 
    -- Headers
    raw.copyFilesWithDirectory(
      wksp.path, 
      path.join( installDir, "include" ), 
      raw.headers )

    -- Copy Library files
    raw.copyFiles( wksp.path, path.join( installDir, "lib" ), raw.libraries )

    -- Copy Binaries files
    raw.copyFiles( wksp.path, path.join( installDir, "bin" ), raw.binaries )
  end



---
-- 
---
  
  newgenerator( raw )