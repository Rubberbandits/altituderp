PLUGIN.name = "Set Char Slot"
PLUGIN.desc = "Allows admin so set the character slot limit"
PLUGIN.author = "Westford"

nut.command.add("charsetslots", {
	syntax = "<string player> <number slots>",
	adminOnly = true,
	onRun = function(ply, args)
		local target = nut.command.findPlayer(ply, args[1])
		local slots = tonumber(args[2])

		if not target or not slots then return end

		target:setNutData("customCharSlots", slots)
		ply:notify(target:Nick() .. " now has " .. slots .. " character slots", NOT_CORRECT)
	end
})

nut.command.add("charresetslots", {
	syntax = "<string player>",
	adminOnly = true,
	onRun = function(ply, args)
		local target = nut.command.findPlayer(ply, args[1])
		
		if not target then return end
		target:setNutData("customCharSlots", nil)

		ply:notify("You resetted " .. target:Nick() .."'s character slots", NOT_CORRECT)
	end
})

if SERVER then
	hook.Add("GetMaxPlayerCharacter", "CustomCharacterSlot", function(ply)
		return ply:getNutData("customCharSlots")
	end)
end