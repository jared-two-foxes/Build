--
-- Build System root file.
-- v0.0.1
--

-----------------------------------------------------------------------------------------------------------------------------------------------------

local buildProjDir = 'C:/Develop/Build' 
package.path = package.path .. ";" .. buildProjDir .. "/src/?.lua;" .. os.getenv("userprofile") .. "/?.lua;"
package.cpath = package.cpath .. ";" .. buildProjDir .. "/Bin/?.dll" 


-----------------------------------------------------------------------------------------------------------------------------------------------------

function _build_main()

  local app     = require 'pl.app'
  local path    = require 'pl.path'
  local pretty  = require 'pl.pretty'
  local tablex  = require 'pl.tablex'
   
  -- app.require_here();

  -- Process the arguments into an easy to use format.
  local flags, parameters = app.parse_args( _ARGV, {toolset=true, configuration=true} )

  local build   = require 'build'
  local project = require 'project'

  if not project.path then
    project.path = path.currentdir()
  end

  -- create the 'build' directory and enter it
  if not path.isdir( "Projects" ) then 
    path.mkdir( "Projects" )
  end

  path.chdir( "Projects" )

  local toolset = "msvc-14.1" -- Visual Studio 15 2017 
  if flags["toolset"] then
    toolset = flags["toolset"]
  elseif flags["t"] then
    toolset = flags["t"]
  end

  local configuration = "Release"
  if flags["configuration"] then
    toolset = flags["configuration"]
  elseif flags["c"] then
    toolset = flags["c"]
  end

  -- Recursively build all the dependencies for the project (some dependencies may have other dependencies etc, etc)
  build.build( project, toolset, configuration )

end
