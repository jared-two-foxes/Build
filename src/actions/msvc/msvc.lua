--
-- msvc.lua
-- 
-- Copyright (c) 2009-2015 Jason Perkins and the Premake project
--

	local b = build
  b.msvc = {}

	local msvc = b.msvc
	




---
-- 
---

	function msvc.compile( project, configuration, prj )
    local compileDir = path.join( _MAIN_SCRIPT_DIR, "_build", project.name )
    os.chdir( compileDir )
    
    local buildCmd = "devenv "

    if project.solution ~= nil then
      buildCmd = buildCmd .. project.solution .. ".sln"
    else
      buildCmd = buildCmd .. project.name .. ".sln"
    end

    buildCmd = buildCmd .." /Build " .. configuration 
    
    if prj then
      buildCmd = buildCmd .. " /project " .. prj
    end

    -- Pipe to an output file.
    buildCmd = buildCmd .. " >> msvc_file.txt"

    os.execute( buildCmd )  
	end
