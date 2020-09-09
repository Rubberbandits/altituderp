--icly, all chat messages in ami are automatically translated to your set language
--for automated messages, its the equivalent in that english,
--for user messages its machine translated (such as google translate),
--so icly its not always perfect
nut.command.add("holonet", {
	desc = "Use local channel, requires a PDA",
	syntax = "<string message>",
	onRun = function(client, arguments)
        if(client:getNetVar("neardeath")) then return end
        if(client:getNetVar("restricted")) then return "You cannot do this while tied!" end

		if(client:getNetVar("isjammed")) then return "Something is preventing you from sending holonet messages." end

		local message = table.concat(arguments, " ")
		local item = client:HasPDA()
        local anonymous = false

        if(client:HasPDA()) then
            if(client:GetPDAHandle() == "invalid" and !client:GetPDAMono()) then return "You need to set up your handle first!" end
	    if(client:GetPDALocalOpt()) then return "You are opted out of global chat." end
        end
        if(nut.plugin.list["pda"].globBan[client:GetPDAID()]) then
            return "You have been banned from using global chat by a system administrator."
        end

		if(message:sub(1, 1) == "?" and message:sub(2):find("%S")) then
			anonymous = true
			message = message:sub(2)
		end

        message = client:GetPDAHandle().."|"..message

		if(item) then
			nut.chat.send(client, "pdalocal", message, anonymous)
		else
			client:notify("You need a holopad to use holonet commands.")
		end
	end,
})

nut.command.add("holonetpm", {
	desc = "PM a specified handle",
	syntax = "<string handle> <string message>",
	onRun = function(client, arguments)
        if(client:getNetVar("neardeath")) then return end
        if(client:getNetVar("restricted")) then return "You cannot do this while tied!" end

		if(client:getNetVar("isjammed")) then return "Something is preventing you from sending holonet messages." end

		local message = table.concat(arguments, " ", 2)
		local target = nil
		local item = client:HasPDA()
        if(item) then
            if(client:GetPDAHandle() == "invalid" and !client:GetPDAMono()) then return "You need to set up your handle first!" end
        end
        for k,v in ipairs(player.GetAll()) do --look through for handles
            if(nut.util.stringMatches(v:GetPDAHandle(), arguments[1])) then
                if(v:GetPDAHandle() == "invalid") then return "You cannot PM someone with an invalid handle!" end
                target = v
                break
            end
        end
        if(!IsValid(target)) then return "Handle not found!" end
		local titem = target:HasPDA()
		local anonymous = false

        if(titem) then
        local block = string.find(target:GetPDABlockList(), tostring(client:GetPDAID()))
        if(block) then
            return "It appears "..target:GetPDAHandle().." has your holonet handle blocked."
        end
        end

		if(message:sub(1, 1) == "?" and message:sub(2):find("%S")) then
			anonymous = true
			message = message:sub(2)
		end

        message = target:GetPDAHandle().."|"..client:GetPDAHandle().."|"..message

		if(IsValid(target)) then
			if(item and titem) then
				nut.chat.send(client, "pdapm", message, anonymous, {client, target})
			elseif(!item) then
				client:notify("You need a holopad to use holonet commands.")
			else
				nut.chat.send(client, "pdapm", message, anonymous, {client})
			end
		end
	end,
})

nut.command.add("holotrade", {
	desc = "Send a message in the trade channel",
	syntax = "<string message>",
	onRun = function(client, arguments)
        if(client:getNetVar("neardeath")) then return end
        if(client:getNetVar("restricted")) then return "You cannot do this while tied!" end

		if(client:getNetVar("isjammed")) then return "Something is preventing you from sending PDA messages." end

		local message = table.concat(arguments, " ")
		local item = client:HasPDA()
		local anonymous = false

        if(item) then
            if(client:GetPDAHandle() == "invalid" and !client:GetPDAMono()) then return "You need to set up your handle first!" end
            if(client:GetPDATradeOpt()) then return "You are opted out of trade chat." end
        end
        if(nut.plugin.list["pda"].tradeBan[client:GetPDAID()]) then
            return "You have been banned from using trade chat by a system administrator."
        end

		if(message:sub(1, 1) == "?" and message:sub(2):find("%S")) then
			anonymous = true
			message = message:sub(2)
		end

        message = client:GetPDAHandle().."|"..message

		if(item) then
			nut.chat.send(client, "pdatrade", message, anonymous)
		else
			client:notify("You need a holopad to use holonet commands.")
		end
	end,
})

nut.command.add("opttrade", {
	desc = "Opt out of the trade channel or opt back in",
    onRun = function(client, arguments)
        local pda = client:GetPDA()

        if(pda) then
            if(pda:getData("pdanotrade")) then
                pda:setData("pdanotrade", nil)
                return "Reenabled trade chat!"
            else
                pda:setData("pdanotrade", true)
                return "Disabled trade chat!"
            end
        end
    end,
})

nut.command.add("optholonet", {
	desc = "Opt out of the holonet global channel or opt back in",
    onRun = function(client, arguments)
        local pda = client:GetPDA()

        if(pda) then
            if(pda:getData("pdanolocal")) then
                pda:setData("pdanolocal", nil)
                return "Reenabled global chat!"
            else
                pda:setData("pdanolocal", true)
                return "Disabled global chat!"
            end
        end
    end,
})

nut.command.add("netfreehandle", {
	desc = "Used to remove the specified handle from any holopad instances that have it, so it should make it available again",
    syntax = "<string handle>",
    onRun = function(client, arguments)
        if(client:getNetVar("neardeath")) then return end
        if(client:getNetVar("restricted")) then return "You cannot do this while tied!" end

        if(!client:getChar():hasFlags("Z")) then
            return "You need sysadmin privileges to do this!"
        end
        
        local count = 0

        for k, v in pairs(nut.item.instances) do
            if(v:getData("pdahandle")) then
                if(nut.util.stringMatches(v:getData("pdahandle"), arguments[1])) then
                    v:setData("pdahandle", "invalid")
                    count = count + 1
                end
            end
        end

        return "Cleared "..count.." holopads with "..arguments[1].." in the handle."
    end
})

nut.command.add("pdasetactivepda", {
	desc = "Set the PDA with that handle as your active pda, no argument will reset it",
    syntax = "[string handle]",
    onRun = function(client, arguments)
        if(client:getNetVar("neardeath")) then return end
        if(client:getNetVar("restricted")) then return "You cannot do this while tied!" end

        if(arguments[1] == "" or !arguments[1]) then
            client:getChar():setData("activePDA", nil, nil, player.GetAll())
            return "Reset active PDA. It will now again use the first one it finds."
        end

        local item = client:GetPDA()
        if(!item) then
            return "Could not find a pda in your inventory!"-- with the specified handle!"
        end

        client:getChar():setData("activePDA", item.id, nil, player.GetAll())
        return "Set active PDA. Commands will now use specifically this PDA, as long as it is in your inventory."
    end,
})

nut.command.add("netforcehandle", {
	desc = "Force the handle of someone in case its something racist or stupid",
    syntax = "<string name> <string handle>",
    adminOnly = true,
    onRun = function(client,arguments)
		local target = nut.util.findPlayer(arguments[1])
		if(!IsValid(target)) then return "No target" end

        local item = target:GetPDA()
        if(!item) then return end

        item:setData("pdahandle", arguments[2]:gsub("%s+", ""), player:GetAll())
        client:notify("Changed the handle of "..target:Name().." to "..arguments[2]:gsub("%s+", ""))
    end
})

nut.command.add("netgetid", {
	desc = "sysadmin thing that gets the pda id for a handle",
    syntax = "<string handle>",
    onRun = function(client,arguments)
        if(client:getNetVar("neardeath")) then return end
        if(client:getNetVar("restricted")) then return "You cannot do this while tied!" end

        if(!client:getChar():hasFlags("Z")) then
            return "You need either sysadmin privileges to do this!"
        end
        local target = nil
        for k,v in ipairs(player.GetAll()) do --look through for handles
            if(nut.util.stringMatches(v:GetPDAHandle(), arguments[1])) then
                if(v:GetPDAHandle() == "invalid") then return "You cannot get the ID of someone with an invalid handle!" end
                target = v
                break
            end
        end
        if(!IsValid(target)) then return "Handle not found!" end

        return "The PDAID for "..target:GetPDAHandle().." is "..tostring(target:GetPDAID())
    end
})
--[[
nut.command.add("pdagetcid", {
	desc = "gets someone cid for a handle",
    syntax = "<string handle>",
    onRun = function(client,arguments)
        if(client:getNetVar("neardeath")) then return end
        if(client:getNetVar("restricted")) then return "You cannot do this while tied!" end

        if(!client:getChar():hasFlags("Z")) then
            return "You need either sysadmin privileges to do this!"
        end
        local target = nil
        for k,v in ipairs(player.GetAll()) do --look through for handles
            if(nut.util.stringMatches(v:GetPDAHandle(), arguments[1])) then
                if(v:GetPDAHandle() == "invalid") then return "You cannot get the ID of someone with an invalid handle!" end
                target = v
                break
            end
        end
        if(!IsValid(target)) then return "Handle not found!" end

        return "The CID attached to "..target:GetPDAHandle().." is "..tostring(target:GetCID())
    end
})
--]]

nut.command.add("netwhois", {
	desc = "sysadmin thing that gets the handle for the specified pda id",
    syntax = "<number id>",
    onRun = function(client, arguments)
        if(client:getNetVar("neardeath")) then return end
        if(client:getNetVar("restricted")) then return "You cannot do this while tied!" end

        if(!client:getChar():hasFlags("Z")) then
            return "You need either sysadmin privileges to do this!"
        end
        
        for k, v in pairs(nut.item.instances) do
            if(v:getData("simid")) then
                if(v:getData("simid") == tonumber(arguments[1])) then
                    return "The current handle for #"..arguments[1].." is "..tostring(v:getData("pdahandle", "invalid"))
                end
            end
        end

        return "A PDA with the ID of "..arguments[1].." was not found!"
    end
})

nut.command.add("hasholopad", {
    syntax = "<string name>",
	desc = "sysadmin thing that gets if the specified person has a pda at all",
    onRun = function(client, arguments)
        if(client:getNetVar("neardeath")) then return end
        if(client:getNetVar("restricted")) then return "You cannot do this while tied!" end

        if(!client:getChar():hasFlags("Z")) then
            return "You need sysadmin privileges to do this!"
        end

		local target = nut.util.findPlayer(arguments[1])
		if(!IsValid(target)) then return "No target" end
        
        return "HasPDA for "..target:Name().." is "..tostring(target:HasPDA())
    end
})

nut.command.add("netgethandle", {
	desc = "sysadmin thing gets the handle for someone",
    syntax = "<string name>",
    onRun = function(client, arguments)
        if(client:getNetVar("neardeath")) then return end
        if(client:getNetVar("restricted")) then return "You cannot do this while tied!" end

        if(!client:getChar():hasFlags("Z")) then
            return "You need sysadmin privileges to do this!"
        end

		local target = nut.util.findPlayer(arguments[1])
		if(!IsValid(target)) then return "No target" end
        
        return "Holonet Handle for "..target:Name().." is "..target:GetPDAHandle()
    end
})

nut.command.add("holonetban", {
	desc = "sysadmin thing to ban/unban someone from using the local channel",
    syntax = "<string handle>",
    onRun = function(client,arguments)
        if(client:getNetVar("neardeath")) then return end
        if(client:getNetVar("restricted")) then return "You cannot do this while tied!" end

        if(!client:getChar():hasFlags("Z")) then
            return "You need sysadmin privileges to do this!"
        end
        local target = nil
        for k,v in ipairs(player.GetAll()) do --look through for handles
            if(nut.util.stringMatches(v:GetPDAHandle(), arguments[1])) then
                if(v:GetPDAHandle() == "invalid") then return "You cannot ban someone with an invalid handle!" end
                target = v
                break
            end
        end
        if(!IsValid(target)) then return "Handle not found!" end

        local id = target:GetPDAID()
        if(nut.plugin.list["pda"].globBan[id]) then
            nut.plugin.list["pda"].globBan[id] = nil
            nut.plugin.list["pda"].SaveBanList()
            return "Unbanned #"..tostring(id).." from global chat."
        end

        nut.plugin.list["pda"].globBan[id] = true
        nut.plugin.list["pda"].SaveBanList()
        return "Banned #"..tostring(id).." from global chat."
    end
})

nut.command.add("holotradeban", {
	desc = "sysadmin thing that bans/unbans someone from using the trade channel",
    syntax = "<string handle>",
    onRun = function(client,arguments)
        if(!client:getChar():hasFlags("Z")) then
            return "You need sysadmin privileges to do this!"
        end
        local target = nil
        for k,v in ipairs(player.GetAll()) do --look through for handles
            if(nut.util.stringMatches(v:GetPDAHandle(), arguments[1])) then
                if(v:GetPDAHandle() == "invalid") then return "You cannot PM someone with an invalid handle!" end
                target = v
                break
            end
        end
        if(!IsValid(target)) then return "Handle not found!" end

        local id = target:GetPDAID()
        if(nut.plugin.list["pda"].tradeBan[id]) then
            nut.plugin.list["pda"].tradeBan[id] = nil
            nut.plugin.list["pda"].SaveBanList()
            return "Unbanned #"..tostring(id).." from trade chat."
        end

        nut.plugin.list["pda"].tradeBan[id] = true
        nut.plugin.list["pda"].SaveBanList()
        return "Banned #"..tostring(id).." from trade chat."
    end
})

nut.command.add("pdablock", {
	desc = "Block the specified handle",
    syntax = "<string target>",
    onRun = function(client,arguments)
        if(client:getNetVar("neardeath")) then return end
        if(client:getNetVar("restricted")) then return "You cannot do this while tied!" end

		if(client:getNetVar("isjammed")) then return "Something is preventing you from sending holonet messages." end

        local item = client:GetPDA()
        if(!item) then return "You need a holopad to use this command!" end

        local target = nil
        for k,v in ipairs(player.GetAll()) do --look through for handles
            if(nut.util.stringMatches(v:GetPDAHandle(), arguments[1])) then
                target = v
                break
            end
        end
        if(!IsValid(target)) then return "Handle not found!" end

        local blocklist = item:getData("pdablocked")
        if(string.find(blocklist, tostring(target:GetPDAID()))) then
            item:setData("pdablocked", blocklist:gsub(tostring(target:GetPDAID()), ""), player.GetAll())
            client:notify("You have unblocked #"..tostring(target:GetPDAID()))
        else
            item:setData("pdablocked", blocklist..","..tostring(target:GetPDAID()), player.GetAll())
            client:notify("You have blocked #"..tostring(target:GetPDAID()))
        end
    end,
})