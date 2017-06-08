
---
-- base/oven.lua
-- Work with the list of registered actions.
-- Copyright (c) 2002-2015 Jason Perkins and the Premake project
---

  local b = build

  b.oven = {}
  local oven = b.oven



---
-- Override point, for logic that should run after validation and
-- before the action takes control.
---

  function oven.preGeneration( wksp )
    printf("Generating project '%s'...", wksp.name)

    -- Create a folder for the project in the 'build' directory and enter it
    local compileDir = path.join( _MAIN_SCRIPT_DIR, "_build", wksp.name )
    
    -- If directory doesnt exist make it.
    if not os.isdir( compileDir ) then
      local ok, err = os.mkdir( compileDir )
      if not ok then                          
        print( "Error: " .. err )
      end
    end

    -- Enter the build directory
    os.chdir( compileDir )
  end


---
-- Trigger an action.
--
-- @param name
--    The name of the action to be triggered.
---

  function oven.execute( wksp, toolset, config )
    if wksp.system then
      local a = b.generator.get( wksp.system )
    
      if a ~= nil then
        local installDir = path.join( _MAIN_SCRIPT_DIR, "_external" )

        if a.generate then
          if os.isfile( "generate.log" ) then
            os.remove( "generate.log" )
          end
          a.generate( wksp, toolset, installDir )
        end

        if a.compile then
          if os.isfile( "compile.log" ) then
            os.remove( "compile.log" )
          end
          a.compile( wksp, toolset, config )
        end

        if a.install then
          if os.isfile( "install.log" ) then
            os.remove( "install.log" )
          end
          a.install( wksp, installDir, config )
        end
      else
        print( "err: Unable to find generator '" .. wksp.system "'" )
      end
    else
      print( "No 'system', skipping" )
    end
  end


---
-- Processing is complete, rest the build state.
---

  function oven.postGeneration()
    -- return to the root build directory
    os.chdir( path.join( _MAIN_SCRIPT_DIR, "_build" ) )
  end


---
--  Extract library definition
---
  local function extractLibrary( name )
    -- Check name for sub components.
    local prj_name
    local parts = string.explode( name, ":" )
    if table.getn( parts ) then
      prj_name = parts[2]
    end

    --todo; Handle the case where name doesn't exist.

    l = b.libraries[ parts[1] ] -- because lua is 1 based.
    if l ~= nil then
      if l.system == "premake5" then
        -- This entry simply points to a workspace file go grab that and merge it with this entry.
        local wksp = require( path.join( l.path, "workspace" ) )
        l = table.merge( l, wksp )
      end
      
      -- Attempt to find a library with the lib name if its specified.
      if prj_name ~= nil then
        --l = l.libraries[prj_name];
        --@todo; Maybe setup the wksp to add in a library entry?
      end
    else
      --todo; attempt to find the library in the workspace?
    end

    return l
  end


---
-- Recursively builds all the dependencies for the project and generates the solution file for this project
-- (some dependencies may have other dependencies etc, etc)
---

  function oven.build( workspace, toolset, config )

    -- Build up the dependencies required by this project.
    local dependencies = {}
    if workspace.dependencies then
      for _, name in pairs(workspace.dependencies) do
        dependencies[name] = extractLibrary(name)
      end
    end

    if workspace.projects then
      for _, project in pairs(workspace.projects) do
        if project.dependencies then
          for _, name in pairs(project.dependencies) do
            dependencies[name] = extractLibrary(name)
          end
        end
      end
    end

    -- Recurse the build call on each dependency.
    if dependencies then  
      for _, library in pairs(dependencies) do
        oven.build( library, toolset, config )
      end
    end

    -- Generate, build and install this workspace.
    oven.preGeneration( workspace )
    oven.execute( workspace, toolset, config )
    oven.postGeneration( workspace );
  end




---
-- Recursively builds all the dependencies for the project and generates the solution file for this project
-- (some dependencies may have other dependencies etc, etc)
---

  function oven.bake()
    oven.build( b.workspace, _OPTIONS["toolset"], _OPTIONS["configuration"] )
  end
