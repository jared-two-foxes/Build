--
--  Nebulae.Build v0.0.1 build script
--


--
-- Remember my location; I will need it to locate sub-scripts later.
--

  local corePath = _SCRIPT_DIR


--
-- Register supporting actions and options.
--

  newaction {
    trigger = "embed",
    description = "Embed scripts in scripts.c; required before release builds",
    execute = function ()
      include (path.join(corePath, "scripts/embed.lua"))
    end
  }


  newaction {
    trigger = "package",
    description = "Creates source and binary packages",
    execute = function ()
      include (path.join(corePath, "scripts/package.lua"))
    end
  }


  newaction {
    trigger = "test",
    description = "Run the automated test suite",
    execute = function ()
      test = require "self-test"
      premake.action.call("self-test")
    end
  }




-----------------------------------------------------------------------------------------------------------------------------------------------------

if _ACTION == "vs2010" then
  platform = 'win'
elseif _ACTION == "vs2013" then
  platform = 'win'
elseif _ACTION == "vs2015" then
  platform = 'win'
elseif _ACTION == "vs2017" then
  platform = 'win'
elseif _ACTION == "xcode4" then --todo.  Need to wildcard match this string to xcode*
  if _OPTIONS['ios'] then
    platform = 'ios'
  else
    platform = 'osx'
  end
else
  print('Unrecogonised action found')
end


-----------------------------------------------------------------------------------------------------------------------------------------------------

baseLocation             = path.getabsolute("./")
solutionLocation         = path.getabsolute("build")

if( false == os.isdir(solutionLocation) ) then
  os.mkdir( solutionLocation )
end


-----------------------------------------------------------------------------------------------------------------------------------------------------

workspace "Build"
  configurations { "debug", "release" }
  language "C"
  location( solutionLocation .. "/Build" )
  flags { "NoEditAndContinue", "FloatFast" }

  includedirs {
    "./"
  }

  filter "action:vs*"
    defines{
      "WIN32",
      "_WIN32" 
    }

    architecture ( "x86_64" )
    buildoptions { "/EHsc", "/MP" }
    systemversion "10.0.14393.0"

    -- ignore some warnings
    linkoptions {
      '/ignore:4221', -- This object file does not define any previously undefined public symbols, so it will not be used by any link operation that consumes this library
      '/WX',          -- treat all other warnings as errors
    }

  filter {}



-----------------------------------------------------------------------------------------------------------------------------------------------------

project "Lua"
  kind "StaticLib"
  language "C"

  includedirs {
    "include",
    "lua/src",
  }

  -- Add all the lua library files
  files {
    "lua/src/lapi.c", 
    "lua/src/lcode.c", 
    "lua/src/ldebug.c", 
    "lua/src/ldo.c", 
    "lua/src/ldump.c", 
    "lua/src/lfunc.c", 
    "lua/src/lgc.c", 
    "lua/src/llex.c", 
    "lua/src/lmem.c", 
    "lua/src/lobject.c", 
    "lua/src/lopcodes.c", 
    "lua/src/lparser.c", 
    "lua/src/lstate.c", 
    "lua/src/lstring.c", 
    "lua/src/ltable.c", 
    "lua/src/ltm.c", 
    "lua/src/lundump.c", 
    "lua/src/lvm.c", 
    "lua/src/lzio.c", 
    "lua/src/lauxlib.c", 
    "lua/src/lbaselib.c", 
    "lua/src/ldblib.c", 
    "lua/src/liolib.c", 
    "lua/src/lmathlib.c", 
    "lua/src/loslib.c", 
    "lua/src/ltablib.c", 
    "lua/src/lstrlib.c", 
    "lua/src/linit.c",
    "lua/src/loadlib.c" }

  filter 'configurations:debug'
    defines { "DEBUG" }
    symbols "On"      
    targetsuffix '_d'
    targetdir ( path.join(baseLocation, "Lib") )

  filter 'configurations:release'
    defines { "NDEBUG" }
    flags { "Optimize" }      
    targetdir ( path.join(baseLocation, "Lib") )



-----------------------------------------------------------------------------------------------------------------------------------------------------


project "Build"
  kind "ConsoleApp"
  language "C++"

  includedirs {
    "include",
    "lua/src",
  }

  files {
    "src/**.h",
    "src/**.cpp",
    "src/**.lua"
  }

  links {
    'Lua',
  }

  filter 'configurations:debug'
    defines { "DEBUG" }
    symbols "On"       
    targetsuffix '_d'
    targetdir ( path.join(baseLocation, "Bin") )

  filter 'configurations:release'
    defines { "NDEBUG" }
    flags { "Optimize" }      
    targetdir ( path.join(baseLocation, "Bin") )
