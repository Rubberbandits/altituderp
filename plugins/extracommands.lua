PLUGIN.name = "Extra Commands"
PLUGIN.author = "Westford"
PLUGIN.desc = "A few useful commands."

nut.command.add("fixpac", {
	syntax = "<No Input>",
	onRun = function(client, arguments)
	timer.Simple(0, function()
						if (IsValid(client)) then
						    client:ConCommand("pac_clear_parts")
						end
					end)
	timer.Simple(0.5, function()
						if (IsValid(client)) then
							client:ConCommand("pac_urlobj_clear_cache")
							client:ConCommand("pac_urltex_clear_cache")
						end
					end)
	timer.Simple(1.0, function()
						if (IsValid(client)) then
							client:ConCommand("pac_restart")
						end
					end)
	timer.Simple(1.5, function()
						if (IsValid(client)) then
							client:ChatPrint("PAC has been successfully restarted. You might need to run this command twice!")
						end
					end)
      end
})

-- nut.command.add("refreshfonts", {
	-- syntax = "<No Input>",
	-- onRun = function(client, arguments)
	-- RunConsoleCommand("fixchatplz")
	-- hook.Run("LoadFonts", nut.config.get("font"))
	-- client:ChatPrint("Fonts have been refreshed!")
    -- end
-- })


nut.command.add("setnick", {
	syntax = "[String Nickname]",
	onRun = function(client, arguments)
		if (arguments[1]) then
			if (!string.find(client:Name(), "'")) then
				local name = string.Split(client:getChar():getName(), " ")
				local newName = name[1].." '"..arguments[1].."' "..name[2]

				client:getChar():setName(newName)
				client:ChatPrint("Your name is now "..newName..".")
			else
				local name = string.Split(client:getChar():getName(), " ")
				string.Split(client:getChar():getName(), " ")
				local newName = name[1].." '"..arguments[1].."' "..name[3]

				client:getChar():setName(newName)
				client:ChatPrint("Your name is now "..newName..".")
			end;
		else
			client:ChatPrint("You need to enter a nickname.")
		end;
	end;
})

nut.command.add("cleardecals", {
	syntax = "",
	onRun = function(client, arguments)
		if not client:IsAdmin() then
			client:notify "You must be an admin to do that!"
			return
		end

		for k, v in pairs(player.GetAll()) do
			v:ConCommand("r_cleardecals")
		end
	end;
})

nut.command.add("removenick", {
	syntax = "[No Input]",
	onRun = function(client, arguments)
		if (!string.find(client:Name(), "'")) then
			client:ChatPrint("No nickname was detected.")
		else
			local name = string.Split(client:getChar():getName(), " ")
			string.Split(client:getChar():getName(), " ")
			local newName = name[1].." "..name[3]

			client:getChar():setName(newName)
			client:ChatPrint("Your name is now "..newName..".")
		end;
	end;
})

nut.command.add("cleanitems", {
	adminOnly = true,
	onRun = function(client, arguments)

	for k, v in pairs(ents.FindByClass("nut_item")) do

		v:Remove()

	end;
		client:notify("All items have been cleaned up from the map.")
	end
})




nut.command.add("rules", {
    syntax = "<No Input>",
	onRun = function(client, arguments)
	 client:SendLua([[gui.OpenURL("https://altituderoleplay.com/board/3/")]])
	end
})

nut.command.add("workshop", {
    syntax = "<No Input>",
	onRun = function(client, arguments)
	client:SendLua([[gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2167258732")]])
	end
})

nut.command.add("discord", {
    syntax = "<No Input>",
	onRun = function(client, arguments)
	 client:SendLua([[gui.OpenURL("https://discord.gg/MXZbMH8")]])
	end
})

nut.command.add("forums", {
    syntax = "<No Input>",
	onRun = function(client, arguments)
	 client:SendLua([[gui.OpenURL("https://altituderoleplay.com/")]])
	end
})

--[[ if SERVER then
timer.Create("Cleanup Decals", 120, 0, function ()
    for _, v in pairs(player.GetHumans()) do
        v:ConCommand("r_cleardecals")
    end
end)
end--]]