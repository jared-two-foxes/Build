
---
-- base/oven.lua
-- Work with the list of registered actions.
-- Copyright (c) 2002-2015 Jason Perkins and the Premake project
---

  local b = build

  b.oven = {}

  local oven      = b.oven
  local startTime = os.clock()


---
-- Set the action to be performed from the command line arguments.
---

  function oven.prepareAction()
    print( _ACTION )

    -- The "next-gen" actions have now replaced their deprecated counterparts.
    -- Provide a warning for a little while before I remove them entirely.
    if _ACTION and _ACTION:endswith("ng") then
      b.warnOnce(_ACTION, "'%s' has been deprecated; use '%s' instead", _ACTION, _ACTION:sub(1, -3))
    end
    b.action.set(_ACTION)

    -- Allow the action to initialize stuff.
    local action = b.action.current()
    if action then
      b.action.initialize(action.trigger)
    end
  end


---
-- Override point, for logic that should run after validation and
-- before the action takes control.
---

  function oven.preAction( project )
    printf("Running action '%s'...", project.name)
    --startTime = os.clock()
  end


---
-- Trigger an action.
--
-- @param name
--    The name of the action to be triggered.
---

  function oven.execute( prj, environment, configuration, installDir )
    local a = b.action.get( prj.system )
    if a ~= nil then
      if a.onGenerate then
        a.onGenerate( prj, environment, configuration, installDir )
      end

      if a.onCompile then
        a.onCompile( prj, environment, configuration )
      end

      if a.onInstall then
        a.onInstall( prj, installDir, configuration )
      end
    end
  end


---
-- Processing is complete.
---

  function oven.postAction( project )
    local duration = math.floor((os.clock() - startTime) * 1000);
    printf("Done (%dms).", duration)
    print();
  end


---
-- Recursively builds all the dependencies for the project and generates the solution file for this project
-- (some dependencies may have other dependencies etc, etc)
---

  function oven.build( project, environment, configuration, installDir )

    local local_install_dir = ''
    if not installDir then
      local_install_dir = project.path
    else
      local_install_dir = installDir
    end

    -- Combine the libraries found in the project file and the root projects (override with project option where applicable)
    local combined_libraries = {}
    if project.libraries then
      combined_libraries = tablex.union( b.libraries, project.libraries )
    else
      combined_libraries = b.libraries
    end

    -- Build the dependency list
    local dependencies = {}
    if project.dependencies then
      for i, name in pairs(project.dependencies ) do
        dependencies[name] = combined_libraries[name]
      end
      
      -- Recurse the build call on each dependency.
      for key, prj in pairs(dependencies) do
        oven.build( prj, environment, configuration, local_install_dir )
      end
    end

    local p = os.getcwd()

    -- Create a folder for the project in the 'build' directory and enter it
    if not os.isdir( project.name ) then 
      os.mkdir( project.name )
    end
    os.chdir( project.name )

    oven.preAction( project )

    oven.execute( project, environment, configuration, local_install_dir )

    --oven.postAction( project );

    -- return to the original path.
    os.chdir( p ) 
  end



---
-- Recursively builds all the dependencies for the project and generates the solution file for this project
-- (some dependencies may have other dependencies etc, etc)
---

  function oven.bake()

    local project = b.project

    if not project.path then
      project.path = os.getcwd()
    end

    -- create the 'build' directory and enter it
    if not os.isdir( "Projects" ) then 
      os.mkdir( "Projects" )
    end

    os.chdir( "Projects" )
    
    startTime = os.clock()

    -- Recursively build all the dependencies for the project (some dependencies may have other dependencies etc, etc)
    oven.build( project, _OPTIONS["toolset"], _OPTIONS["configuration"] )

  end