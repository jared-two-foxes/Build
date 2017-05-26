---
-- action.lua
-- Work with the list of registered actions.
-- Copyright (c) 2002-2015 Jason Perkins and the Premake project
---

	local b = build
	b.action = {}

	local action = b.action


--
-- The list of registered actions. Calls to newaction() will add
-- new entries here.
--

	action._list = {}


---
-- Register a new action.
--
-- @param act
--    The new action object.
---

	function action.add(act)
		-- validate the action object, at least a little bit
		local missing
		for _, field in ipairs({"description", "trigger"}) do
			if not act[field] then
				missing = field
			end
		end

		if missing then
			local name = act.trigger or ""
			error(string.format('action "%s" needs a  %s', name, missing), 3)
		end

		if act.os ~= nil then
			b.warnOnce(act.trigger, "action '" .. act.trigger .. "' sets 'os' field, which is deprecated, use 'targetos' instead.")
			act.targetos = act.os
			act.os = nil
		end

		action._list[act.trigger] = act
	end



---
-- Initialize an action.
--
-- @param name
--    The name of the action to be initialized.
---

	function action.initialize(name)
		local a = action._list[name]
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

	function action.get(name)
		return action._list[name]
	end


---
-- Iterator for the list of actions.
---

	function action.each()
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
