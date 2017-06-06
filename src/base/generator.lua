---
-- action.lua
-- Work with the list of registered actions.
-- Copyright (c) 2002-2015 Jason Perkins and the Premake project
---

	local b = build
	b.generator = {}

	local generator = b.generator


--
-- The list of registered actions. Calls to newaction() will add
-- new entries here.
--

	generator._list = {}


---
-- Register a new generator.
--
-- @param act
--    The new action object.
---

	function generator.add(act)
		-- validate the action object, at least a little bit
		local missing
		for _, field in ipairs({"description", "trigger"}) do
			if not act[field] then
				missing = field
			end
		end

		if missing then
			local name = act.trigger or ""
			error(string.format('generator "%s" needs a  %s', name, missing), 3)
		end

		generator._list[act.trigger] = act
	end



---
-- Initialize an generator.
--
-- @param name
--    The name of the action to be initialized.
---

	function generator.initialize(name)
		local a = generator._list[name]
		if a.onInitialize then
			a.onInitialize()
		end
	end




---
-- Retrieve an action by name.
--
-- @param name
--    The name of the action to retrieve.
-- @returns
--    The requested action, or nil if the action does not exist.
---

	function generator.get(name)
		return generator._list[name]
	end


---
-- Iterator for the list of actions.
---

	function generator.each()
		-- sort the list by trigger
		local keys = { }
		for _, act in pairs(action._list) do
			table.insert(keys, act.trigger)
		end
		table.sort(keys)

		local i = 0
		return function()
			i = i + 1
			return action._list[keys[i]]
		end
	end
