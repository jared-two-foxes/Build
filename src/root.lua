--
-- Build System root file.
-- v0.0.1
--

-----------------------------------------------------------------------------------------------------------------------------------------------------

local buildProjDir = 'C:/Develop/Build' 

package.path = package.path .. ";" .. buildProjDir .. "/src/?.lua;" .. os.getenv("userprofile") .. "/?.lua;"
package.cpath = package.cpath .. ";" .. buildProjDir .. "/Bin/?.dll" 


-----------------------------------------------------------------------------------------------------------------------------------------------------

local path    = require 'pl.path'
local build   = require 'build'

-- Add the executing path to the path
package.path = package.path .. path.currentdir() .. "/?.lua"

local project = require 'project'

if not project.path then
  project.path = path.currentdir()
end

-- create the 'build' directory and enter it
if not path.isdir( "Projects" ) then 
  path.mkdir( "Projects" )
end

path.chdir( "Projects" )

-- Recursively build all the dependencies for the project (some dependencies may have other dependencies etc, etc)
build.build( project, "msvc-14.1", "Release" )
