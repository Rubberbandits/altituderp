PLUGIN.name = "Advertising"

PLUGIN.author = "Westford"

PLUGIN.desc = "Adds a few useful commands."



nut.chat.register("announcement", {

	onCanSay =  function(speaker, text)

		return speaker:IsAdmin()

	end,

	onCanHear = 1000000,

	onChatAdd = function(speaker, text)

		chat.AddText(Color(255, 0, 250), " [Admin Announcement] ", color_white, text)

	end,

	prefix = {"/announce"}

})




--[[
nut.chat.register("advert", {

	onCanSay =  function(speaker, text)	

		if speaker:getChar():hasMoney(0) then

				speaker:getChar():takeMoney(50)

				speaker:notify("Your advertisement has been posted successfully and $50 has been deducted from your account.")

			return true

		else 

			speaker:notify("You lack sufficient funds to advertise.")

			return false 

		end

		end,

	onChatAdd = function(speaker, text)

		chat.AddText( Color(255, 238, 0), " [Advertisement by " .. speaker:Nick() .. "] ", color_white, text)

	end,

	prefix = {"/advertisement"},

	noSpaceAfter = true,

	filter = "advertisements"

})



nut.chat.register("rumour", {

	onCanSay =  function(speaker, text)

		if speaker:getChar():hasMoney(50) then

				speaker:getChar():takeMoney(50)

				speaker:notify("$50 has been deducted from your account for illegal advertising.")

			return true

		else 

			speaker:notify("You lack sufficient funds to illegally advertise.")

			return false 

		end

		end,

	onChatAdd = function(speaker, text)

		chat.AddText( Color(255, 76, 0), " [Underground Advertisement] ", color_white, text)

	end,

	onCanHear = function(speaker, listener)

	if listener:Team() == FACTION_BUSINESS or listener:Team() == FACTION_EMT or listener:Team() == FACTION_FBI or listener:Team() == FACTION_MIAMIGOV or listener:Team() == FACTION_SWAT or listener:Team() == FACTION_POLICE or listener:Team() == FACTION_NEWS or listener:Team() == FACTION_ESTATE or listener:Team() == FACTION_PRISON then 

	return false

	else

	return true

	end

	end,

	prefix = {"/rumour"},

	noSpaceAfter = true,
	filter = "advertisements"

})



nut.chat.register("911", {

    onCanSay =  function(speaker, text)

        if speaker:Team() == FACTION_CERBERUS or speaker:Team() == FACTION_MEGAMED then

            speaker:notify("Use your personal radio.")

            return false

        else

            return true

        end

    end,

    onChatAdd = function(speaker, text)

        chat.AddText( Color(255, 0, 0), "[911 Call from " ..speaker:Nick().."]", color_white, text)

    end,

    onCanHear = function(speaker, listener)

    if listener:Team() == FACTION_CERBERUS or listener:Team() == FACTION_MEGAMED or listener:Team() == FACTION_SWAT or speaker == listener then --make sure to replace "POLICE" with whatever you've called your police faction index.

    return true

    else

    return false

    end

    end,

    prefix = {"/911"},

    noSpaceAfter = true,

    filter = "IC"

})
--]]


function PLUGIN:PlayerLoadedChar(client, id)

    client:notify('Welcome to Altitude Roleplay, if you need help getting started, use /discord to join our official discord or contact staff with @.')

end



