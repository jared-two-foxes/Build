--
-- xcode_common.lua
-- Functions to generate the different sections of an Xcode project.
-- Copyright (c) 2009-2015 Jason Perkins and the Premake project
--

	local b = build

	b.modules.cmake = {}

	local cmake = b.modules.cmake
	

---
-- Attempts to run cmake with the specified options as described by the project object
---

	function cmake.generate( prj, environment, configuration, installDir )

      	local cmd = prj.system .. ' -G"Visual Studio 15 2017 Win64"' 

      	if prj.naming == "standard " then
        	cmd = cmd .. ' -DCMAKE_DEBUG_POSTFIX="d"'
      	end

    	cmd = cmd .. ' -DCMAKE_INSTALL_PREFIX="' .. installDir .. '"';

      	if prj.build_defines ~= nil then
        	for key, value in pairs( prj.build_defines ) do
          		cmd = cmd .. ' -D' .. value
        	end
      	end

      	cmd = cmd .. " " .. prj.path

      	-- Generate solution
      	print( cmd  )
      	os.execute( cmd )
      	print()
	end


---
--
---

	function cmake.compile( project, environment, configuration )
      	local cmd  = "devenv " 
      	if project.solution ~= nil then
        	cmd = cmd .. project.solution .. ".sln"
      	else
        	cmd = cmd .. project.name .. ".sln"
      	end
      	local conf = " /Build " .. configuration

      	local buildCmd   = cmd .. conf
      	print( buildCmd )
      	os.execute( buildCmd ) 
      	print()
	end


---
--
---

	function cmake.install( project, installDir, configuration ) 

		local cmd  = "devenv " 
		if project.solution ~= nil then
			cmd = cmd .. project.solution .. ".sln"
		else
			cmd = cmd .. project.name .. ".sln"
		end
		local conf = " /Build " .. configuration
		local project  = " /project INSTALL.vcxproj"

		local buildCmd   = cmd .. conf .. project  
		os.execute( buildCmd ) 
		print()
	end