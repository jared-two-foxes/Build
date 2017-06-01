--
-- _build_main.lua
-- Script-side entry point for the main program logic.
-- Copyright (c) 2002-2015 Jason Perkins and the Premake project
--

	local shorthelp     = "Type 'build --help' for help"
	local versionhelp   = "Build (Project Generation and Dependency Management) %s"
	local startTime     = os.clock()

-- set a global.
	_BUILD_STARTTIME = startTime

-- Load the collection of core scripts, required for everything else to work

	local modules = dofile("_modules.lua")
	local manifest = dofile("_manifest.lua")
	for i = 1, #manifest do
		dofile(manifest[i])
	end


-- Create namespaces for myself

	local b = build
	b.main = {}

	local m = b.main

	b.workspace = {};
	local p = b.workspace


-- Keep a table of modules that have been preloaded, and their associated
-- "should load" test functions.

	m._preloaded = {}


---
-- Add a new module loader that knows how to use the Premake paths like
-- PREMAKE_PATH and the --scripts option, and follows the module/module.lua
-- naming convention.
---

	function m.installModuleLoader()
		table.insert(package.loaders, 2, m.moduleLoader)
	end

	function m.moduleLoader(name)
		local dir = path.getdirectory(name)
		local base = path.getname(name)

		if dir ~= "." then
			dir = dir .. "/" .. base
		else
			dir = base
		end

		local full = dir .. "/" .. base .. ".lua"

		-- list of paths where to look for the module
		local paths = {
			".modules/" .. full,
			"modules/" .. full,
			full,
			name .. ".lua"
		}

		-- try to locate the module
		for _, p in ipairs(paths) do
			local file = os.locate(p)
			if file then
				local chunk, err = loadfile(file)
				if chunk then
					return chunk
				end
				if err then
					return "\n\tload error " .. err
				end
			end
		end

		-- didn't find the module in supported paths, try the embedded scripts
		for _, p in ipairs(paths) do
			local chunk, err = loadfile("$/" .. p)
			if chunk then
				return chunk
			end
		end
	end


---
-- Prepare the script environment; anything that should be done
-- before the system script gets a chance to run.
---

	function m.prepareEnvironment()
		math.randomseed(os.time())
		_BUILD_DIR = path.getdirectory(_BUILD_COMMAND)
		b.path = b.path .. ";" .. _BUILD_DIR .. ";" .. _MAIN_SCRIPT_DIR
	end


---
-- Load the required core modules that are shipped as part of Premake and
-- expected to be present at startup. If a _preload.lua script is present,
-- that script is run and the return value (a "should load" test) is cached
-- to be called after baking is complete. Otherwise the module's main script
-- is run immediately.
---

	function m.preloadModules()
		for i = 1, #modules do
			local name = modules[i]
			local preloader = name .. "/_preload.lua"
			preloader = os.locate("modules/" .. preloader) or os.locate(preloader)
			if preloader then
				m._preloaded[name] = include(preloader)
				if not m._preloaded[name] then
					b.warn("module '%s' should return function from _preload.lua", name)
				end
			else
				require(name)
			end
		end
	end


---
-- Look for and run the system-wide configuration script; make sure any
-- configuration scoping gets cleared before continuing.
---

	function m.runSystemScript()
		dofileopt(_OPTIONS["systemscript"] or "build-system.lua")

		b.libraries = dofile( "libraries.lua" ) -- this appears to be a similar idea?
	end


---
-- Look for a user project script, and set up the related global
-- variables if I can find one.
---

	function m.locateUserScript()
		local defaults = { "workspace.lua" }
		for i = 1, #defaults do
			if os.isfile(defaults[i]) then
				_MAIN_SCRIPT = defaults[i]
				break
			end
		end

		if not _MAIN_SCRIPT then
			_MAIN_SCRIPT = defaults[1]
		end

		if _OPTIONS.file then
			_MAIN_SCRIPT = _OPTIONS.file
		end

		_MAIN_SCRIPT = path.getabsolute(_MAIN_SCRIPT)
		_MAIN_SCRIPT_DIR = path.getdirectory(_MAIN_SCRIPT)
	end


---
-- If there is a project script available, run it to get the
-- project information, available options and actions, etc.
---

	function m.runUserScript()
		if os.isfile(_MAIN_SCRIPT) then
			b.workspace = dofile(_MAIN_SCRIPT)
		end
	end



---
-- Validate and process the command line options and arguments.
---

	function m.processCommandLine()
		-- Process special options
		if (_OPTIONS["version"]) then
			printf(versionhelp, _PREMAKE_VERSION)
			os.exit(0)
		end

		if (_OPTIONS["help"]) then
			b.showhelp()
			os.exit(1)
		end

		-- Validate the command-line arguments. This has to happen after the
		-- script has run to allow for project-specific options
		ok, err = b.option.validate(_OPTIONS)
		if not ok then
			print("Error: " .. err)
			os.exit(1)
		end
	end


---
-- Override point, for logic that should run before baking.
---

	function m.preBake()
		-- any modules need to load to support this project?
		for module, func in pairs(m._preloaded) do
			if not package.loaded[module] then
				require(module)
			end
		end

    	print("Building solution ..." )

	    -- create the 'build' directory and enter it
	    -- todo - pass in the name of the build directory.
	    if not os.isdir( "_build" ) then 
	      os.mkdir( "_build" )
	    end
	end


---
-- "Bake" the project information, preparing it for use by the action.
---

	function m.bake()
	
	    -- Grab the project that we are about to attempt to build and set the .
	    b.workspace.path = os.getcwd()
	      
		b.oven.bake()
	end


---
-- Processing is complete.
---

  	function m.postBake()
		local duration = math.floor((os.clock() - startTime) * 1000);
		printf("Done (%dms).", duration)
	end


--
-- Script-side program entry point.
--

	m.elements = {
		m.installModuleLoader,
		m.locateUserScript,
		m.prepareEnvironment,
		m.preloadModules,
		m.runSystemScript,
		m.runUserScript,
		m.processCommandLine,
		m.preBake,
		m.bake,
		m.postBase,
	}

	function _build_main()
		b.callArray( m.elements )
		return 0
	end
