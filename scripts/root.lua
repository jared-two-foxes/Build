--
-- Application Sample build script
-- v0.0.1
--

dependenciesRoot = 'D:/Develop/Build'
package.path = package.path .. ";" .. dependenciesRoot .. "/?.lua"

-----------------------------------------------------------------------------------------------------------------------------------------------------


local tablex    = require 'pl.tablex'
local path      = require 'pl.path'
local pretty    = require "pl.pretty"
local build     = require 'scripts.build'
local libraries = require 'scripts.libraries' --root library file
local project   = require 'project'

print( 'Root Build script!' )
print( path.currentdir() )

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
build.compile( dependencies, "msvc-14.0" )
build.install( dependencies )

-- Build the actual project solution/workspace
build.generate( project.system )