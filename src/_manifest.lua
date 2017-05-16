--
-- _manifest.lua
-- Manage the list of built-in Premake scripts.
-- Copyright (c) 2002-2015 Jason Perkins and the Premake project
--

-- The master list of built-in scripts. Order is important! If you want to
-- build a new script into Premake, add it to this list.

	return
	{
		-- core files
		"base/_foundation.lua",
		"base/string.lua",
		"base/table.lua",
		"base/path.lua",
		"base/os.lua",
		"base/io.lua",
		-- "base/globals.lua",
		-- "base/moduledownloader.lua",
		-- "base/semver.lua",
		-- "base/http.lua",
		-- "base/json.lua",
		-- "base/jsonwrapper.lua",
		-- "base/languages.lua",

		-- -- runtime switches
		"base/option.lua",
		"base/action.lua",

		-- -- project script setup
		-- "base/api.lua",

		-- -- project script processing
		"base/oven.lua",
		-- "base/validation.lua",
		-- "base/premake.lua",
		-- "base/help.lua",

		-- -- tool APIs
		-- "tools/dotnet.lua",
		-- "tools/gcc.lua",
		-- "tools/msc.lua",
		-- "tools/snc.lua",
		-- "tools/clang.lua",

		-- -- Clean action
		-- "actions/clean/_clean.lua",

		-- "_build_init.lua",
	}
