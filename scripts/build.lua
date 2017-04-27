
local path      = require 'pl.path'
local libraries = require 'scripts.libraries' --root library file

local build = {}

local function SetupEnvironment( system )
  print( "Setting up Environment" )
  if system == "msvc" then
    -- @todo: Determine which flavour of msvc were looking at?
  end

  if system == "msvc-14.0" then
    print( "Changing directory for msvc-14.0 build" )
    ok, err = path.chdir( "C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC" )
    if ( not ok ) then
      print( "err: " .. err )
    end
  elseif system == "msvc-14.1" then
    print( "Changing directory for msvc-14.1 build" )
    ok, err = path.chdir( "C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/VC/Auxiliary/Build" )
    if ( not ok ) then
      print( "err: " .. err )
    end
  end
  print( "executing: vcvarsall x64" )
  os.execute( "vcvarsall x64" )
  print()
end

function build.build( project, environment )
{
  -- @todo:  Recursively build all the dependencies for the project (some dependencies may have other dependencies etc, etc)

  -- Combine the libraries found in the project file and the root projects (override with project option where applicable)
  local combined_libraries = {}
  if project.libraries then
    combined_libraries = tablex.union( libraries, project.libraries )
  else
    combined_libraries = libraries
  end

  -- Extract the dependency information 
  local dependencies = tablex.intersection( combined_libraries, project.dependencies )

  -- Execute the setup & install steps for the 
  build.compile( dependencies, environment )
  build.install( dependencies )

  -- Build the actual project solution/workspace
  build.generate( project.system )
}


-- @todo - Seperate the Preload the CMakeCache file. (Configure step). ??
-- @todo - Allow for clean building of dependencies by deleting cached files ??
-- @todo - Seperate the build list from the library list...
function build.compile( libraries, environment )
  
  -- Setup the build environment
  SetupEnvironment( environment )

  for libName, libDef in pairs( libraries ) do
    local rootPath, buildEngine, dependencies, libNameRelease, libNameDebug = unpack( libDef )

    if ( buildEngine ~= nil ) then
      print( "===========================================================" )
      print( "Building " .. libName )
      print()


      -- Enter the Root directory for this dependency
      ok, err = path.chdir( rootPath )
      if( not ok ) then
        print( "err:" .. err )
      else

        if( buildEngine == "cmake" ) then
          -- Only delete the file if we are attempting to do a clean build? 
          -- Delete any existing build directory to make sure that we have a "clean" build
          -- if os.isdir( "build" ) then
          --   ok, err = os.rmdir( rootPath .. "/build" )
          -- end

          -- create the directory and enter it
          if not path.isdir( "build" ) then 
            path.mkdir( "build" )
          end

          -- Navigate to the build directory 
          path.chdir( "build" )
          print( path.currentdir() )

          -- Run the solution builder process
          -- Attempt to build with the specified compilier
          -- Set the output directory to install the files.
          local cmd = buildEngine .. ' -G"Visual Studio 14 2015 Win64"' .. ' -DCMAKE_INSTALL_PREFIX="' .. rootPath .. '/built" -DCMAKE_DEBUG_POSTFIX="d"'
  
          -- Generate solution
          print( cmd .. " .." )
          os.execute( cmd .. " .." )
          print()

          local buildCmd = buildEngine .. " --build . --target install"
          
          -- Build the project debug and release configurations
          os.execute( "msbuild install.vcxproj /p:configuration=debug;platform=x64;WarningLevel=0" ) -- /v:q" )
          print()
          os.execute( "msbuild install.vcxproj /p:configuration=release;platform=x64;WarningLevel=0" ) -- /v:q" )
          print()
          print( "done" )
        elseif ( buildEngine == "boost.build" ) then
          -- Modular boost via git requires that we call this to copy all them headers to the right location.
          os.execute( "b2 headers" )
          
          -- Build and install!
          os.execute( "b2 --toolset=msvc-14.0 --build-type=complete address-model=64 --architecture=ia64 --threading=multi --link=static --prefix=built -j8 install" )
          print()
          print( "done" )
        end 
      end
      print()
    end
  end
end
 
function build.install( libraries ) 
  
end

function build.generate( system )

end


return build