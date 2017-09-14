--
-- genie.lua
-- Functions to generate solution files based upon the genie build system.
-- Copyright (c) 2016-2017 Jared Watt and the Build project
--

  local b = build

  b.genie = {}

  local genie = b.genie
  genie.trigger = "genie"
  genie.description = "Generates workspace files using genie"
  

---
--  Attempt to create a solution by running genie.
---

  function genie.generate( wksp, toolset, configuration )
    local buildCmd = "genie" 
    buildCmd = buildCmd .. " --file=" .. wksp.path .."/genie.lua"
    buildCmd = buildCmd .. " --outdir=" .. os.getcwd()
    buildCmd = buildCmd .. " " .. toolset 

    os.execute( buildCmd .. ">> generate.log" )
  end


---
--  Attempt to compile the workspace.
---
  function genie.compile( wksp, toolset, configuration )
    b.msvc.compile( wksp, configuration )
  end


---
--  Attempt to install generated files to a useable location.
---

  function genie.install( wksp, installDir, configuration )
    if installDir ~= nil then
      b.raw.copyFilesWithDirectory( 
        path.join( wksp.path, "BrofilerCore" ), 
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
--  Assign the genie generator to the internal generators list.
---
  
  newgenerator( genie )