--
-- Application Sample build script
-- v0.0.1
--

dependenciesRoot = 'D:/Develop/Build/scripts'
package.path = package.path .. ";" .. dependenciesRoot

-----------------------------------------------------------------------------------------------------------------------------------------------------

print( 'Build script!' )


local build     = require 'scripts.build'
local libraries = require 'scripts.libraries'

local pretty = require 'pl.pretty'

-- pretty.print_r( libraries )

build.compile( libraries, dependenciesRoot )
