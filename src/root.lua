--
-- Build System root file.
-- v0.0.1
--

-----------------------------------------------------------------------------------------------------------------------------------------------------

local buildProjDir = 'C:/Develop/Build' 
package.path = package.path .. ";" .. buildProjDir .. "/src/?.lua;" .. os.getenv("userprofile") .. "/?.lua;"
package.cpath = package.cpath .. ";" .. buildProjDir .. "/Bin/?.dll" 


-----------------------------------------------------------------------------------------------------------------------------------------------------

local app     = require 'pl.app'
local path    = require 'pl.path'
local pretty  = require 'pl.pretty'
 
app.require_here();

print( #_G.arg )

-- Get the arguments from the command line.  For some reason the arg[0] is empty and arg[1] contains the
-- program name so we only really care if the argc is > 2
local args = {}
local i = 0
for j, v in ipairs( _G.arg ) do 
  if j > 1 then
    args[i] = v
    i = i + 1
  end
end

pretty.dump( args )

-- Process the arguments into an easy to use format.
local flags, parameters = app.parse_args( args, {toolset=true, configuration=true} )

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
--build.build( project, toolset, configuration )
