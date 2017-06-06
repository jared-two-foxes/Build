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

	function msvc.compile( wksp, config, prj )
    
    local buildCmd = "devenv "

    if wksp.solution ~= nil then
      buildCmd = buildCmd .. wksp.solution .. ".sln"
    else
      buildCmd = buildCmd .. wksp.name .. ".sln"
    end

    buildCmd = buildCmd .." /Build " .. config 
    
    if prj then
      buildCmd = buildCmd .. " /project " .. prj
    end

    os.execute( buildCmd .. " >> compile.txt" )  
	end
