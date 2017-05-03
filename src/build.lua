
local libraries = require 'libraries' --root library file

local path      = require 'pl.path'
local pretty    = require 'pl.pretty'
local tablex    = require 'pl.tablex'
local file      = require 'pl.file'
local dir       = require 'pl.dir'

local build = {}


-- Recursively builds all the dependencies for the project and generates the solution file for this project
-- (some dependencies may have other dependencies etc, etc)
function build.build( project, environment, installDir )
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

  print( "===========================================================" )
  print( "Building " .. project.name )
  print()

  local p = path.currentdir()

  -- Create a folder for the project in the 'build' directory and enter it
  if not path.isdir( project.name ) then 
    path.mkdir( project.name )
  end
  path.chdir( project.name )

  -- Build the project solution/workspace
  build.generate( project, environment, installDir )

  -- Compile the project
  build.compile( project, environment, "release" )

  -- Install compiled projects to the correct locations.
  build.install( project, installDir, "release" )

  -- return to the original path.
  path.chdir( p ) 
end


function build.generate( project, environment, installDir )
  if project.system == 'premake5' then
    local cmd = "premake5" .. " vs2017 --file=" .. project.path .."/premake5.lua"
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
    local cmd = project.system .. ' -G"Visual Studio 15 2017 Win64"' 

    if project.naming == "standard " then
      cmd = cmd .. ' -DCMAKE_DEBUG_POSTFIX="d"'
    end

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
    os.execute( "b2 --toolset=" .. environment .. " --build-type=complete address-model=64 --architecture=ia64 --threading=multi --link=static --prefix=built -j8 install" )
  end 

  print()
end

-- "/p:configuration=debug;platform=x64;WarningLevel=0" --v:q"

-- @todo - Seperate the Preload the CMakeCache file. (Configure step). ??
-- @todo - Allow for clean building of dependencies by deleting cached files ??
-- @todo - Seperate the build list from the library list...
function build.compile( project, environment, configuration )
  if project.system == "premake5" or project.system == "cmake" then
    local cmd  = "devenv " 
    if project.solution ~= nil then
      cmd = cmd .. project.solution .. ".sln"
    else
      cmd = cmd .. project.name .. ".sln"
    end
    local conf = " /Build " .. configuration
    local out  = " /out ReleaseLog.txt"

    local buildCmd   = cmd .. conf  -- .. out
    print( buildCmd )
    os.execute( buildCmd ) 
    print()
  elseif ( project.system == "boost.build" ) then
    -- Build and install!
    os.execute( "b2 --toolset=" .. environment .. " --build-type=complete address-model=64 --architecture=ia64 --threading=multi --link=static --prefix=built -j8 install" )
    print()
  end

  print()
end
 

function build.install( project, installDir, configuration ) 
  if project.system == "cmake"  then
    local cmd  = "devenv " 
    if project.solution ~= nil then
      cmd = cmd .. project.solution .. ".sln"
    else
      cmd = cmd .. project.name .. ".sln"
    end
    local conf = " /Build " .. configuration
    local project  = " /project INSTALL.vcxproj"

    local buildCmd   = cmd .. conf .. project  
    os.execute( buildCmd ) 
    print()
  elseif project.system == "premake5" then
    -- Premake doesnt support compiling and it definitely doesnt support installing.  Furthermore we probably dont actually want to install unless this isn't the 'toplevel' project which is signified by installDir not being set.
    if installDir then
      -- Headers
      local headerFiles = dir.getallfiles( project.path .. "/Source", "**.hpp" )
      for i, filename in pairs(headerFiles) do
        local relpath = path.relpath( filename, project.path .. "/Source" )
        file.copy( filename, path.join( installDir, "include", project.name, relpath ) )
      end
    end

    -- Determine the 'root' level for install
    local p = project.path
    if installDir ~= nil then
      p = installDir 
    end

    -- Copy Library files
    local libraryFiles = dir.getallfiles( "./", "**.lib" )
    for i, filename in pairs( libraryFiles ) do
      _, name = path.splitpath( filename )    -- Grab the filename
      local dst = path.join( p, "Lib", name ) -- determine the destination file.
      local dstDir, _ = path.splitpath( dst ) -- Split the destination to grab out the directory portion.
      if not path.isdir( dstDir ) then        -- Check if the directory exists.
        local ret, err = path.mkdir( dstDir ) -- Attempt to make the directory if it doesnt.
        if not ret then                       -- Check that the directory creation succeeded.
          print( "Error: " + err )
        end
      end
      file.copy( path.abspath( filename ), dst )  -- Copy the file.
    end

    -- Binaries
    local binFiles = dir.getallfiles( "./", "**.exe|**.dll" )
    print( binFiles )
    for i, filename in pairs( binFiles ) do
      _, name = path.splitpath( filename )
      local dst = path.join( p, "Bin", name ) -- determine the destination file.
      local dstDir, _ = path.splitpath( dst ) -- Split the destination to grab out the directory portion.
      if not path.isdir( dstDir ) then        -- Check if the directory exists.
        local ret, err = path.mkdir( dstDir ) -- Attempt to make the directory if it doesnt.
        if not ret then                       -- Check that the directory creation succeeded.
          print( "Error: " + err )
        end
      end
      file.copy( path.abspath( filename ), dst )  -- Copy the file.
    end
  end
end


return build