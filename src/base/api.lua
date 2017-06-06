--
-- api.lua
-- Implementation of the workspace, project, and configuration APIs.
-- Author Jason Perkins
-- Copyright (c) 2002-2015 Jason Perkins and the Premake project
--

	local b = build


--
-- Define a new action.
--
-- @param a
--    The new action object.
--

	function newaction(a)
		b.action.add(a)
	end


--
-- Define a new generator.
--
-- @param opt
--    The new generator object.
--

	function newgenerator(g)
		b.generator.add(g)
	end

--
-- Define a new option.
--
-- @param opt
--    The new option object.
--

	function newoption(opt)
		b.option.add(opt)
	end


