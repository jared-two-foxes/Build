--
--  Nebulae.Build v0.0.1 build script
--

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
  flags { "Symbols", "NoMinimalRebuild", "NoEditAndContinue", "FloatFast" }

  defines {
    "PREMAKE5"
  }

  includedirs {
    "./"
  }

  filter "action:vs*"
    defines{
      "NOMINMAX",
      "WIN32",
      "_WIN32" 
    }

    architecture ( "x86_64" )
    buildoptions { "/EHsc", "/MP" }

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
    flags { "Symbols" }       
    targetsuffix '_d'
    targetdir ( path.join(baseLocation, "Lib") )

  filter 'configurations:release'
    defines { "NDEBUG" }
    flags { "Optimize" }      
    targetdir ( path.join(baseLocation, "Lib") )


-----------------------------------------------------------------------------------------------------------------------------------------------------

project "lfs"
  kind "SharedLib"
  language "C"

  includedirs {
    "include",
    "lua/src",
  }

  -- Add all the lua library files
  files {
    "luafilesystem/src/lfs.c", 
    "luafilesystem/src/lfs.h",  }

  links {
    'Lua'
  }

  filter 'configurations:debug'
    defines { "DEBUG" }
    flags { "Symbols" }       
    targetdir ( path.join(baseLocation, "Bin") )

  filter 'configurations:release'
    defines { "NDEBUG" }
    flags { "Optimize" }      
    targetdir ( path.join(baseLocation, "Bin") )


-----------------------------------------------------------------------------------------------------------------------------------------------------


project "Build"
  kind "ConsoleApp"
  language "C++"

  includedirs {
    "include",
    "lua/src",
  }

  files {
    "src/main.cpp"
  }

  links {
    'Lua',
    'lfs',
  }

  filter 'configurations:debug'
    defines { "DEBUG" }
    flags { "Symbols" }       
    targetsuffix '_d'
    targetdir ( path.join(baseLocation, "Bin") )

  filter 'configurations:release'
    defines { "NDEBUG" }
    flags { "Optimize" }      
    targetdir ( path.join(baseLocation, "Bin") )
