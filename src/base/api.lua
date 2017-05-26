--
-- api.lua
-- Implementation of the workspace, project, and configuration APIs.
-- Author Jason Perkins
-- Copyright (c) 2002-2015 Jason Perkins and the Premake project
--

	local b = build
	b.api = {}

	local api = b.api



-- ---
-- -- Start a new block of configuration settings, using the old, "open"
-- -- style of matching without field prefixes.
-- ---

-- 	function configuration(terms)
-- 		if terms then
-- 			if (type(terms) == "table" and #terms == 1 and terms[1] == "*") or (terms == "*") then
-- 				terms = nil
-- 			end
-- 			configset.addblock(api.scope.current, {terms}, os.getcwd())
-- 		end
-- 		return api.scope.current
-- 	end



-- ---
-- -- Start a new block of configuration settings, using the new prefixed
-- -- style of pattern matching.
-- ---

-- 	function filter(terms)
-- 		if terms then
-- 			if (type(terms) == "table" and #terms == 1 and terms[1] == "*") or (terms == "*") then
-- 				terms = nil
-- 			end
-- 			local ok, err = configset.addFilter(api.scope.current, {terms}, os.getcwd())
-- 			if not ok then
-- 				error(err, 2)
-- 			end
-- 		end
-- 	end



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
-- Define a new option.
--
-- @param opt
--    The new option object.
--

	function newoption(opt)
		b.option.add(opt)
	end
