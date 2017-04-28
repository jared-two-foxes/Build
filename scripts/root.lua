--
-- Application Sample build script
-- v0.0.1
--

dependenciesRoot = 'C:/Develop/Build'
package.path = package.path .. ";" .. dependenciesRoot .. "/?.lua;" .. "C:/Develop/Build/Bin/Release/?.lua"
package.cpath = package.cpath .. ";" .. dependenciesRoot .. "/Bin/?.dll" 

-----------------------------------------------------------------------------------------------------------------------------------------------------

local build   = require 'scripts.build'
local project = require 'project'
local path    = require 'pl.path'

if not project.path then
  project.path = path.currentdir()
end

-- create the 'build' directory and enter it
if not path.isdir( "build" ) then 
  path.mkdir( "build" )
end

path.chdir( "build" )

-- Recursively build all the dependencies for the project (some dependencies may have other dependencies etc, etc)
build.build( project, "msvc-14.1" )
