
local libraries = require 'scripts.libraries' --root library file

local path      = require 'pl.path'
local pretty    = require 'pl.pretty'
local tablex    = require 'pl.tablex'

local build = {}


-- Recursively builds all the dependencies for the project and generates the solution file for this project
-- (some dependencies may have other dependencies etc, etc)
function build.build( project, environment, installDir )
  print( "===========================================================" )
  print( "Building " .. project.name )
  print()

  local local_install_dir = ''
  if not installDir then
    local_install_dir = project.path
  else
    local_install_dir = installDir
  end

  -- Combine the libraries found in the project file and the root projects (override with project option where applicable)
  local combined_libraries = {}
  if project.libraries then
    combined_libraries = tablex.union( libraries, project.libraries )
  else
    combined_libraries = libraries
  end

  -- Build the dependency list
  local dependencies = {}
  if project.dependencies then
    for i, name in pairs(project.dependencies ) do
      --dependencies = tablex.intersection( combined_libraries, project.dependencies )
      dependencies[name] = combined_libraries[name]
    end
    
    -- Recurse the build call on each dependency.
    for key, prj in pairs(dependencies) do
      build.build( prj, environment, local_install_dir )
    end
  end

  local p = path.currentdir()

  -- Create a folder for the project in the 'build' directory and enter it
  if not path.isdir( project.name ) then 
    path.mkdir( project.name )
  end
  path.chdir( project.name )

  -- Build the project solution/workspace
  build.generate( project, environment, installDir )

  -- Compile the project
  build.compile( project, environment )

  -- Install compiled projects to the correct locations.
  --build.install( project )

  -- return to the original path.
  path.chdir( p ) 
end


function build.generate( project, environment, installDir )
  if project.system == 'premake5' then
    local cmd = "premake5" .. " vs2015 --file=" .. project.path .."/premake5.lua"
    print( cmd )
    os.execute( cmd )
  elseif( project.system == "cmake" ) then
    -- Only delete the file if we are attempting to do a clean build? 
    -- Delete any existing build directory to make sure that we have a "clean" build
    -- if os.isdir( "build" ) then
    --   ok, err = os.rmdir( rootPath .. "/build" )
    -- end

    -- Run the solution builder process
    -- Attempt to build with the specified compilier
    -- Set the output directory to install the files.
    local cmd = project.system .. ' -G"Visual Studio 15 2017 Win64"' .. ' -DCMAKE_DEBUG_POSTFIX="d"'

    if installDir then
      cmd = cmd .. ' -DCMAKE_INSTALL_PREFIX="' .. installDir .. '"';
    end

    cmd = cmd .. " " .. project.path

    -- Generate solution
    print( cmd  )
    os.execute( cmd )
    print()
  elseif ( project.system == "boost.build" ) then
    -- Modular boost via git requires that we call this to copy all them headers to the right location.
    os.execute( "b2 headers" )
    
    -- Build and install?
    --os.execute( "b2 --toolset=msvc-14.0 --build-type=complete address-model=64 --architecture=ia64 --threading=multi --link=static --prefix=built -j8 install" )
  end 

  print( "done" )
  print()
end


-- @todo - Seperate the Preload the CMakeCache file. (Configure step). ??
-- @todo - Allow for clean building of dependencies by deleting cached files ??
-- @todo - Seperate the build list from the library list...
function build.compile( project )
  if project.system == "cmake"  then
    -- Build the project debug and release configurations
    os.execute( "msbuild install.vcxproj /p:configuration=debug;platform=x64;WarningLevel=0" ) -- /v:q" )
    print()
    os.execute( "msbuild install.vcxproj /p:configuration=release;platform=x64;WarningLevel=0" ) -- /v:q" )
    print()
  elseif project.system == "premake5" then
    local cmd = "msbuild "
    cmd = cmd .. project.name .. ".sln "
    cmd = cmd .. "/p:configuration=release;platform=x64;WarningLevel=0"
    -- /v:q" )
    print( cmd )
    os.execute( cmd ) 
    print()
  elseif ( project.system == "boost.build" ) then
    -- Build and install!
    os.execute( "b2 --toolset=msvc-14.0 --build-type=complete address-model=64 --architecture=ia64 --threading=multi --link=static --prefix=built -j8 install" )
    print()
  end

  print( "done" )
  print()
end
 

function build.install( project ) 
  
end


return build