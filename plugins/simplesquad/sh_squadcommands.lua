-- Debug Commands for Bugtesting

-- [[ COMMANDS ]] --


--[[
	COMMAND: /printsquads
	DESCRIPTION: Prints all currently populated squads to the console.
]]

nut.command.add("printsquads", {
	syntax = "<none>",
	description = "Prints the squads.",
	onRun = function(client, arguments)
		for k, v in pairs(nut.squadsystem.squads) do
			print(k.." = {")
			for i, j in pairs(v) do
				print("     "..i.." = "..util.TypeToString(j.member)..", "..util.TypeToString(j.color))
			end
			print('}')
		end
	end
})

--[[
	COMMAND: /printsquadinfo
	DESCRIPTION: Prints a player's squad info to the console.
]]

nut.command.add("printsquadinfo", {
	syntax = "<string player>",
	description = "prints squad info of target.",

	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])
		local squadInfo = target:getData("squadInfo")

		print(squadInfo)
		print(type(squadInfo))

		if squadInfo then
			print(squadInfo.squad)
			print(squadInfo.color)
		else
			print("no squad info")
		end
	end
})

--[[
	COMMAND: /clearsquadinfo
	DESCRIPTION: Clears the squad info of a player.
]]

nut.command.add("clearsquadinfo", {
	syntax = "<player>",
	description = "Clears squad info of target.",

	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])
		target:clearSquadInfo()
	end
})

--[[
	COMMAND: /syncallsquads
	DESCRIPTION: Resyncs all squads with the server's information.
]]

nut.command.add("syncallsquads", {
	syntax = "<none>",
	description = "Resyncs all squads.",
	onRun = function(self, client)
		--local target = nut.command.findPlayer(client, arguments[1])
		for k, _ in pairs(nut.squadsystem.squads) do
			nut.squadsystem.syncSquad(k)
		end
	end
})