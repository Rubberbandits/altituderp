local charMeta = nut.meta.character or {}

-- [[ FUNCTIONS ]] --

--[[ 
	FUNCTION: charMeta:getSquad()
	DESCRIPTION: Returns the character's current squad or nil
]]--

function charMeta:getSquad()
	local squadInfo = self:getData("squadInfo") --used to be ()("squadInfo")
	local squad = nil

	if squadInfo then
		squad = squadInfo.squad
	end
	
	return squad
end

--[[ 
	FUNCTION:charMeta:clearSquadInfo()
	DESCRIPTION: Clears a character's squad info.
]]--

function charMeta:clearSquadInfo()
	self:setData("squadInfo", nil)
end

--[[ 
	FUNCTION: charMeta:setSquadColor(color)
	DESCRIPTION: Sets the squad color of a character, which appears to other players.
]]--

function charMeta:setSquadColor(color)
	local squadInfo = self:getData("squadInfo", nil)
	local client = self:getPlayer()
	local colorTable = {
		red = Color(255, 0, 0),
		green = Color(0, 255, 0),
		blue = Color(0, 0, 255),
		yellow = Color(255, 255, 0),
		white = Color(255, 255, 255),
	}

	if (colorTable[color]) then
		squadInfo.color = colorTable[color]

		self:setData("squadInfo", squadInfo)

		for _, v in pairs(nut.squadsystem.squads[squadInfo.squad]) do
			if v.member == client then
				v.color = colorTable[color]
			end
		end

		client:notify("You have set your color to "..color..'.')
	else
		client:notify("Invalid color.")
	end

	nut.squadsystem.syncSquad(squadInfo.squad)
end