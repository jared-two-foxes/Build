--
-- Application Sample build script
-- v0.0.1
--

dependenciesRoot = 'D:/Develop/Build'
package.path = package.path .. ";" .. dependenciesRoot .. "/?.lua"

-----------------------------------------------------------------------------------------------------------------------------------------------------

print( 'Root Build script!' )
print( path.currentdir() )

local build     = require 'scripts.build'
local libraries = require 'scripts.libraries' --root library file
local project   = require 'project.lua'
local tablex    = require 'pl.tablex'

local combined_libraries = tablex.intersection( libraries, project.dependencies )

local pretty = require "pl.pretty"

pretty.print_r( combined_libraries )

--build.compile( combined_libraries, dependenciesRoot )
