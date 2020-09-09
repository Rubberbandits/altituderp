local PLUGIN = PLUGIN



local WOUND_BROKEN = 1

local WOUND_BULLET = 2



local playerMeta = FindMetaTable("Player")



if(SERVER) then

	--updates a player's speed based on their injuries

	function playerMeta:speedUpdate()

		local injuries = self:getInjuries()

		

		local totalBreak = 0

		

		for part, injuryTable in pairs(injuries) do

			for injuryType, injury in pairs(injuryTable) do

				if(injuryType != WOUND_BROKEN) then continue end



				totalBreak = totalBreak + injury

			end

		end

		

		local speedW = nut.config.get("walkSpeed")

		local speedR = nut.config.get("runSpeed")

		

		self:SetWalkSpeed(math.max(speedW - totalBreak, 50))

		self:SetRunSpeed(math.max(speedR - totalBreak * 2, 50))

	end



--resets a player's health stats to default

	function playerMeta:resetHealthStatus()

		local char = self:getChar()

		if(!char) then return end

		

		local healthStatus = {}



		healthStatus.blood = 1000

		healthStatus.oxygen = 1000

		healthStatus.heart = 1000

		

		char:setData("health", healthStatus)

	end



	--sets a player's health stats to specific numbers

	function playerMeta:setHealthStatus(blood, oxygen, heart)

		local char = self:getChar()

		local healthStatus = char:getData("health", {})

		

		if(blood) then

			healthStatus.blood = math.Clamp(blood, 0, 1000)

		end

		

		if(oxygen) then

			healthStatus.oxygen = math.Clamp(oxygen, 0, 1000)

		end

		

		if(heart) then

			healthStatus.heart = math.Clamp(heart, 0, 1000)

		end

		

		char:setData("health", healthStatus)

	end

	

	--sets a player's health stats to specific numbers

	function playerMeta:addHealthStatus(var, amt)

		local char = self:getChar()

		local healthStatus = char:getData("health", {})

		

		if(!healthStatus[var]) then return false end

		

		healthStatus[var] = math.Clamp(healthStatus[var] + amt, 0, 1000)



		char:setData("health", healthStatus)

	end

	

	--adds a specified injury to a player

	function playerMeta:addInjury(part, inj, value)

		local char = self:getChar()

		

		if(PLUGIN:injuryCompatible(part, inj)) then --makes sure the injury is compatible with the part, aka no "broken stomach"

			local injury = char:getData("injury", {})

			

			injury[part] = injury[part] or {}

			

			injury[part][inj] = (injury[part][inj] or 0) + value

			

			char:setData("injury", injury)



			self:updateLoss() --updates global (serverside) loss table

			

			--chat prints when you get certain injuries, so people know what's happening to them better basically

			if(PLUGIN.parts[part].name) then

				if(inj == WOUND_BULLET) then

					--local injuryString = "You have been shot in the " ..PLUGIN.parts[part].name.. "."

					--nut.chat.send(self, "health", injuryString)

				end

				

				if(inj == WOUND_BROKEN) then

					if((self.nextLegPrint or 0) < CurTime()) then

						self.nextLegPrint = CurTime() + 10

						

						local injuryString = "Your " ..PLUGIN.parts[part].name.. " has been damaged."

						nut.chat.send(self, "health", injuryString)

					end

				end

			end

		end

	end

	

	--removes a specified injury from a player

	function playerMeta:removeInjury(part, inj, value)

		local char = self:getChar()

		local injury = char:getData("injury", {})

		injury[part] = injury[part] or {}

		

		injury[part][inj] = (injury[part][inj] or 0) - value

		

		if(injury[part][inj] <= 0) then

			injury[part][inj] = nil --this is stored in the db so we dont really want it there if we dont need it.

		end



		if(table.IsEmpty(injury[part])) then

			injury[part] = nil --dont want it if we dont need it

		end

		

		char:setData("injury", injury)

		

		self:updateLoss() --updates global (serverside) loss table

	end

end



--gets all the player's injuries

function playerMeta:getInjuries()

	local char = self:getChar()

	

	return char:getData("injury", {})

end



--returns player health status

function playerMeta:getHealthStatus()

	local char = self:getChar()

	local healthStatus = char:getData("health", {})



	--default values

	healthStatus.blood = healthStatus.blood or 1000

	healthStatus.oxygen = healthStatus.oxygen or 1000

	healthStatus.heart = healthStatus.heart or 1000

	

	return healthStatus

end



--returns the rate of bleeding based on the injuries the player has

function playerMeta:updateLoss()

	local char = self:getChar()

	local charID = char:getID()

	local injuries = char:getData("injury", {})



	local loss = {}

	

	loss.bleed = 0

	loss.oxyLoss = 0

	for part, injuryTbl in pairs(injuries) do

		for injuryType, injury in pairs(injuryTbl) do

			local limbInfo = PLUGIN.parts[part]

			

			if(limbInfo.bleed and PLUGIN.injuries[injuryType].bleed) then

				loss.bleed = loss.bleed + limbInfo.bleed * injury

			end

			

			if(limbInfo.oxyLoss and PLUGIN.injuries[injuryType].oxyLoss) then

				loss.oxyLoss = loss.oxyLoss + (limbInfo.oxyLoss * 1.5) * injury

			end			

		end

	end

	

	PLUGIN.NUTINJURIES[self] = loss --for serverside health management

	self:setNetVar("loss", loss) --for clientside visual effects

	

	return loss

	

end



--specifically returns blood

function playerMeta:getBlood()

	local char = self:getChar()

	local healthStatus = char:getData("health", {})



	return healthStatus.blood

end



--specifically returns oxygen

function playerMeta:getOxygen()

	local char = self:getChar()

	local healthStatus = char:getData("health", {})



	return healthStatus.oxygen

end



--spexifically returns heart rate

function playerMeta:getHeart()

	local char = self:getChar()

	local healthStatus = char:getData("health", {})



	return healthStatus.heart

end