--
-- _build_init.lua
--
-- Prepares the runtime environment for the add-ons and user project scripts.
--
-- Copyright (c) 2012-2015 Jason Perkins and the Premake project
--

	local b = build


---
--
-- Install build's default set of command line arguments.
--
---

	newoption
	{
		trigger     = "toolset",
		value       = "VALUE",
		description = "Choose a toolset",
		default     = "msvc-14.1"
		-- allowed = {
		-- 	{ "msvc-14.1",   "Microsoft .NET (csc)" },
		-- 	{ "premake", "Novell Mono (mcs)"    },
		-- 	{ "boost",   "Portable.NET (cscc)"  },
		-- }
	}

	newoption
	{
		trigger     = "configuration",
		value       = "VALUE",
		description = "Choose a configuration to install",
		default     = "release"
		-- allowed = {
		-- 	{ "msvc-14.1",   "Microsoft .NET (csc)" },
		-- 	{ "premake", "Novell Mono (mcs)"    },
		-- }
	}

	newoption
	{
		trigger     = "file",
		value       = "FILE",
		description = "Read FILE as a Premake script; default is 'premake5.lua'"
	}

	newoption
	{
		trigger     = "help",
		description = "Display this information"
	}

	newoption
	{
		trigger     = "scripts",
		value       = "PATH",
		description = "Search for additional scripts on the given path"
	}

	newoption
	{
		trigger     = "systemscript",
		value       = "FILE",
		description = "Override default system script (premake5-system.lua)"
	}

	newoption
	{
		trigger     = "version",
		description = "Display version information"
	}