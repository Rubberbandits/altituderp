PLUGIN.name = "Door Extensions"
PLUGIN.author = "Zoephix"
PLUGIN.desc = "A extension for the doors plugin, adding easy commands that target every door."

local PLUGIN = PLUGIN

function PLUGIN:InitializedPlugins()
	local doorPlugin = nut.plugin.list["doors"]

	if (!doorPlugin) then return end

	nut.command.add("doorsetunownableall", {
		adminOnly = true,
		onRun = function(client, arguments)
			-- Get every door entity
			for _, entity in pairs(ents.GetAll()) do
				-- Validate it is a door.
				if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
					-- Set it so it is unownable.
					entity:setNetVar("noSell", true)
	
					doorPlugin:callOnDoorChildren(entity, function(child)
						child:setNetVar("noSell", true)
					end)
					
					doorPlugin:SaveDoorData()
				end
			end
	
			-- Tell the player they have made the doors unownable.
			client:notify("You have made every door unownable.")
		end
	})
	
	nut.command.add("doorsetownableall", {
		adminOnly = true,
		onRun = function(client, arguments)
			-- Get every door entity
			for _, entity in pairs(ents.GetAll()) do
				-- Validate it is a door.
				if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
					-- Set it so it is ownable.
					entity:setNetVar("noSell", nil)
	
					doorPlugin:callOnDoorChildren(entity, function(child)
						child:setNetVar("noSell", nil)
					end)
					
					doorPlugin:SaveDoorData()
				end
			end
	
			-- Tell the player they have made the doors ownable.
			client:notify("You have made every door ownable.")
		end
	})
	
	nut.command.add("doorsetdisabledall", {
		adminOnly = true,
		syntax = "<bool disabled>",
		onRun = function(client, arguments)
			local disabled = util.tobool(arguments[1] or true)
	
			-- Get every door entity
			for _, entity in pairs(ents.GetAll()) do
				-- Validate it is a door.
				if (IsValid(entity) and entity:isDoor()) then
	
					-- Set it so it is ownable.
					entity:setNetVar("disabled", disabled)
	
					doorPlugin:callOnDoorChildren(entity, function(child)
						child:setNetVar("disabled", disabled)
					end)
					
					doorPlugin:SaveDoorData()
				end
			end
	
			-- Tell the player they have made the doors (un)disabled.
			if (disabled) then
				client:notify("You have disabled every door.")
			else
				client:notify("You have undisabled every door.")
			end
		end
	})
	
	nut.command.add("doorsethiddenall", {
		adminOnly = true,
		syntax = "<bool hidden>",
		onRun = function(client, arguments)
			local hidden = util.tobool(arguments[1] or true)
	
			-- Get every door entity
			for _, entity in pairs(ents.GetAll()) do
				-- Validate it is a door.
				if (IsValid(entity) and entity:isDoor()) then
	
					entity:setNetVar("hidden", hidden)
					
					doorPlugin:callOnDoorChildren(entity, function(child)
						child:setNetVar("hidden", hidden)
					end)
					
					doorPlugin:SaveDoorData()
				end
			end
	
			-- Tell the player they have made the doors (un)disabled.
			if (hidden) then
				client:notify("You have hidden every door.")
			else
				client:notify("You have unhidden every door.")
			end
		end
	})
end