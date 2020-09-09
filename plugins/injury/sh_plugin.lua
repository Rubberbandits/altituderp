local PLUGIN = PLUGIN

PLUGIN.name = "Injury/Medical System"

PLUGIN.author = "It's A Joke"

PLUGIN.desc = "Handles injuries and medical treatments for them."



nut.util.include("injuryfall.lua")



local WOUND_BROKEN = 1

local WOUND_BULLET = 2



--health observations, picks a string based on the level that the variable is at.

local function healthObs(var, number)

	local varTbl = PLUGIN.thresh[var]

	if(varTbl) then

		local responses

		local key

		for k, v in SortedPairs(varTbl) do

			if(number <= k) then

				responses = v

				key = k

				

				break

			end

		end



		return responses, key

	end

end



local function bleedVisual(time, pos)

	if(pos != Vector(0,0,0)) then --prevents invalid positioning

		local bleed = ents.Create("info_particle_system")

		

		bleed:SetKeyValue("effect_name", "blood_impact_red_01")

		

		bleed:SetPos( pos )

		bleed:Spawn()

		bleed:Activate()

		bleed:Fire("Start", "", 0)

		bleed:Fire("Kill", "", time)

	end

end



local function bleedSpurt(target)

	local effectdata = EffectData()

	effectdata:SetOrigin(target:GetPos())

	--effectdata:SetNormal(ang:Up())

	--effectdata:SetColor(bt)

	effectdata:SetEntity(target)

	util.Effect("blood_spurt", effectdata)

end



--gets how severe an injury is based on the number

local function getSeverity(injury)

	local severity = {

		[0] = "Healing",

		[10] = "Minor",

		[50] = "Moderate",

		[100] = "Severe",

		[1000000] = "Extremely Severe", --this one is really big because it uses <=, so anything greater than 100 is life threatening

	}



	local responses = "" --default value, used for when the injury isn't causing any harm anymore

	for k, v in SortedPairs(severity) do

		if(injury <= k) then

			responses = v

			break

		end

	end

	

	return responses

end



--checks if the injury is compatible with the part

function PLUGIN:injuryCompatible(part, injury)

	local injury = PLUGIN.injuries[injury]

	

	if(injury.groups[part]) then

		return true

	else

		return false

	end

end



local playerMeta = FindMetaTable("Player")



if(SERVER) then

	PLUGIN.NUTINJURIES = PLUGIN.NUTINJURIES or {}



	--used to get the hitgroup from the dmginfo

	local function getHitGroup(dmginfo)

		local attacker = dmginfo:GetAttacker()

		local trace = {}

		if(attacker:IsPlayer() or attacker:IsNPC()) then

			trace.start = attacker:GetShootPos()

				

			trace.endpos = trace.start + ( ( dmginfo:GetDamagePosition() - trace.start ) * 2 )  

			trace.mask = MASK_SHOT

			trace.filter = attacker

				

			local tr = util.TraceLine( trace )

			

			return tr.HitGroup

		else

			return false

		end

	end

	function PLUGIN:EntityTakeDamage(entity, dmgInfo)

		local dmg = dmgInfo:GetDamage()

		local dmgT = dmgInfo:GetDamageType()	

	

		local inflictor = dmgInfo:GetInflictor()

	

		if(IsValid(entity) and entity:IsPlayer()) then

			--local hitgroup = entity:LastHitGroup()

			local hitgroup = getHitGroup(dmgInfo)
			local modifier
			local armorItem
			local absorbedDamage
			local absorbedDamagePerc

			if (entity:getChar() && entity:getChar():getInv()) then
				for k,v in pairs(entity:getChar():getInv():getItems()) do
					if (v.protects && v.protects[hitgroup] && v.protects[hitgroup] > 0) then
						if (v:getData("equip") && v:getData("dura", v.dura or 100) > 0 && (!modifier || v.protects[hitgroup] > modifier)) then
							modifier = v.protects[hitgroup]
							armorItem = v
						end
					end
				end
			end

			
			if (armorItem) then
				modifier = math.Clamp(modifier, 0, 1)
				absorbedDamage = math.min(dmg * modifier, armorItem:getData("dura", armorItem.dura or 100), dmg)
				absorbedDamagePerc = math.Clamp(absorbedDamage / dmg, 0, 1)
				armorItem:setData("dura", math.max(armorItem:getData("dura", armorItem.dura or 100) - absorbedDamage, 0))
				dmgInfo:SetDamage(dmg - absorbedDamage)
				dmg = dmg - absorbedDamage
			end
			

			local attacker = dmgInfo:GetAttacker()

			

			if(entity:HasGodMode()) then return end --ignore god mode people

			

			if(((dmgT == DMG_BULLET or dmgT == 4098) or (attacker and attacker:IsPlayer())) and hitgroup and PLUGIN.parts[hitgroup]) then --bullet damage at a specific hitgroup
				if (S2K && !S2K.Active()) then return end
				local blockedInjury = false
				if (armorItem && modifier && absorbedDamagePerc > 0) then
					if (absorbedDamagePerc >= 1) then
						blockedInjury = true
					else
						blockedInjury = math.random() < absorbedDamagePerc
					end
				end

				if (!blockedInjury) then
					entity:addInjury(hitgroup, WOUND_BULLET, dmg * 0.5) --bullet injuries
					entity:addInjury(hitgroup, WOUND_BROKEN, dmg * 10) --mostly for broken legs, wont apply to anything else anyways
				end
				--bleedVisual(1, dmgInfo:GetDamagePosition())

				

			elseif(dmgT == DMG_FALL and dmg > 15) then --fall damage

				if(math.random(1,2) == 1) then --randomly chooses to break the left or the right leg

					entity:addInjury(HITGROUP_LEFTLEG, WOUND_BROKEN, dmg)

				else

					entity:addInjury(HITGROUP_RIGHTLEG, WOUND_BROKEN, dmg)

				end

				

				--makes player fallover for a few seconds when they take fall damage

				timer.Simple(0.05, function()

					if(!IsValid(entity.nutRagdoll)) then

						entity:setRagdolled(true, 3)

					end

				end)				

			elseif(dmgT == DMG_DROWN) then --drowning damage

				local healthStatus = entity:getHealthStatus()

				entity:setHealthStatus(nil, healthStatus.oxygen - 100, nil)

			end

			

			if(entity:Health() - dmg <= 0 and !IsValid(entity.nutRagdoll)) then

				dmgInfo:SetDamage(entity:Health() - 1) --makes it so people dont die to killing blows

				timer.Simple(0.5, function()

					if(IsValid(entity)) then

						entity:SetHealth(1)

					end

				end)

				

				local velo = dmgInfo:GetDamageForce() * 0.01

				

				entity:setRagdolledI(true, nil, nil, nil, velo)

				entity:setNetVar("uncon", true)

			end

			

			--updates player speeds based on injuries

			entity:speedUpdate()

			

			if(IsValid(inflictor) and (inflictor:GetClass() == "gmod_sent_vehicle_fphysics_base" or inflictor:GetClass() == "gmod_sent_vehicle_fphysics_wheel")) then

				if(!IsValid(entity:GetVehicle())) then

					if((entity.nextVDMG or 0) < CurTime()) then

						entity.nextVDMG = CurTime() + 5

					

						dmgInfo:SetDamage(15)

					end

				

					if(!IsValid(entity.nutRagdoll)) then

						entity:setRagdolled(true, 5)

					end

				end

			end

		end

		

		if (IsValid(entity.nutPlayer)) then

			if (dmgInfo:IsDamageType(DMG_CRUSH)) then

				if ((entity.nutFallGrace or 0) < CurTime()) then

					if (dmgInfo:GetDamage() <= 10) then

						dmgInfo:SetDamage(0)

					end



					entity.nutFallGrace = CurTime() + 0.5

				else

					return

				end

			end

			

			local hp = entity.nutPlayer:Health()

			if(hp - dmg <= 0 and hp > 1) then

				dmgInfo:ScaleDamage(0)

				

				timer.Simple(0.5, function()

					if(IsValid(entity.nutPlayer)) then

						entity.nutPlayer:SetHealth(1)

					end

				end)

			end

			

			entity.nutPlayer:TakeDamageInfo(dmgInfo)

		end

	end



	--when a player fully dies, reset their health values

	function PLUGIN:PlayerDeath(victim, inflictor, attacker)

		victim:resetHealthStatus()

		

		victim:getChar():setData("injury", nil)

		victim:getChar():setData("injurypost", nil)

		

		PLUGIN.NUTINJURIES[victim] = nil

		

		victim.lastThresh = {}

		

		victim:setNetVar("loss", nil) --for clientside visual effects

		victim:setNetVar("dead", nil) --whether they're dead or not

		victim:setNetVar("uncon", nil) --whether they're unconscious or not

		

		victim.oldGroup = victim:GetCollisionGroup()

		victim:SetCollisionGroup(COLLISION_GROUP_DEBRIS) --should fix people becoming invisible walls sometimes

	end

	

	--should fix people becoming invisible walls sometimes

	function PLUGIN:PlayerLoadout(client)

		if(client.oldGroup) then

			client:SetCollisionGroup(client.oldGroup)

			client.oldGroup = nil

		end

		

		client:resetHealthStatus()

		

		if(client:getChar()) then

			client:getChar():setData("injury", nil)

			client:getChar():setData("injurypost", nil)

		end

		

		PLUGIN.NUTINJURIES[client] = nil

		

		client.lastThresh = {}

		

		client:setNetVar("loss", nil) --for clientside visual effects

		client:setNetVar("dead", nil) --whether they're dead or not

		client:setNetVar("uncon", nil) --whether they're unconscious or not

		

		--mask vars

		if(client:getNetVar("mask")) then

			client:removePart("oxygen_mask")

			client:setNetVar("mask", nil)

		end

	end

	

	--when a player fully dies, reset their health values

	function PLUGIN:PlayerLoadedChar(client)

		client:updateLoss()

		PLUGIN:MovementCheck(client)

	end

	

	function PLUGIN:breathSounds(client, oxygen)

		if(oxygen > 900) then return false end

	

		--[[

		if((client.lastBreath or 0) < CurTime()) then

			client.lastBreath = CurTime() + 5.5

			

			client:EmitSound("male_heavybreathing.mp3", 50)

		end

		--]]

		

		timer.Create(client:Name().."breath", 5, 2, function()

			--if((client.lastHeartBeat or 0) < CurTime()) then

				netstream.Start(client, "nut_playsound", "male_heavybreathing.mp3")

			--end

		end)		

	end	

	

	function PLUGIN:heartSounds(client, heart)

		if(heart > 900) then return false end



		timer.Create(client:Name().."heart", 3, 4, function()

			if((client.lastHeartBeat or 0) < CurTime()) then

				if(heart < 950) then

					--client.lastHeartBeat = CurTime() + 2.5



					netstream.Start(client, "nut_playsound", "heartbeat_normal.mp3")

				elseif(heart < 500) then

					netstream.Start(client, "nut_playsound", "heartbeat_fast.mp3")

				end

			end

		end)

	end

	

	--think loop, handles status loss due to injuries

	function PLUGIN:Think()

		if((self.nextCheck or 0) < CurTime()) then

			self.nextCheck = CurTime() + 10

			

			--goes through all the players

			for k, client in pairs(player.GetAll()) do

				local char = client:getChar()

				if(char) then

					local healthStatus = client:getHealthStatus() --health stats (blood, oxygen, heart rate)



					--health values restore themselves slowly if no injuries

					local bleed = -5 --blood losss

					local oxyLoss = -10 --oxygen loss

					local heartLoss = -20 --heart rate increase (decrease for code)

					

					if(client:getNetVar("mask")) then

						client:EmitSound("oxygenmasksounds.mp3")

						oxyLoss = -500

					end

					

					if(PLUGIN.NUTINJURIES[client]) then

						bleed = bleed + (PLUGIN.NUTINJURIES[client].bleed or 0)

						bleed = bleed * (1 + (1000 - healthStatus.heart) * 0.0005) --increases blood loss when heart rate is higher (lower for code)

						

						if(bleed > 10) then

							bleedSpurt(client)

						end

						

						oxyLoss = oxyLoss + (PLUGIN.NUTINJURIES[client].oxyLoss or 0)

						heartLoss = heartLoss + (PLUGIN.NUTINJURIES[client].bleed or 0)



						--notifies players in chat based on their health statuses

						PLUGIN:healthNotify(client, healthStatus) 

						

						--cleans up healed or removed injuries from PLUGIN.NUTINJURIES

						PLUGIN:nutInjuriesClean(client) 

						

						client:setNetVar("loss", PLUGIN.NUTINJURIES[client])

					else

						if(char:getData("injurypost")) then

							if(math.random(1,100) == 1) then

								client:TakeDamage(1, client, client)

								

								nut.chat.send(client, "health", "Your old injuries hurt.")

								

								--this is for the visual effects

								client:setNetVar("oldInj", true)

								timer.Simple(5, function()

									client:setNetVar("oldInj", nil)

								end)

							end

						end

					end

					

					if(healthStatus and !client:getNetVar("dead")) then

						PLUGIN:breathSounds(client, healthStatus.oxygen)

						PLUGIN:heartSounds(client, healthStatus.heart)

					end

					

					--updates health status

					client:setHealthStatus(healthStatus.blood - bleed, healthStatus.oxygen - oxyLoss, healthStatus.heart - heartLoss)

					

					--function that checks health stats, and if they're bad enough it'll kill the player

					PLUGIN:healthDeathCheck(client, healthStatus)

					

					PLUGIN:MovementCheck(client)

				end

			end

		end

	end

	

	--this cleans up empty tables or healed injuries so we dont have to check them in our think loop anymore

	function PLUGIN:nutInjuriesClean(client)

		for inj, v in pairs(PLUGIN.NUTINJURIES[client]) do

			if(v == 0) then

				PLUGIN.NUTINJURIES[client][inj] = nil

			end

		end

		

		if(table.IsEmpty(PLUGIN.NUTINJURIES[client])) then

			PLUGIN.NUTINJURIES[client] = nil

		end

	end

	

	--notifies the player of their current body status while they are injured

	function PLUGIN:healthNotify(client, healthStatus)

		if((client.nextHealthNotify or 0) < CurTime()) then

			client.nextHealthNotify = CurTime() + 30

			

			if(client:getNetVar("dead")) then return end --if they're dead we don't need to tell them about their blood levels or etc

			

			if(!client.lastThresh) then

				client.lastThresh = {}

			end

			

			--these are temporary until I make a system for thresholds

			if((client.lastThresh["blood"] or 1000) > healthStatus.blood) then

				local obs, key = healthObs("blood", healthStatus.blood)

			

				nut.chat.send(client, "health", obs.self)

				client.lastThresh["blood"] = key

			end

			

			if((client.lastThresh["heart"] or 1000) > healthStatus.heart) then

				local obs, key = healthObs("heart", healthStatus.heart)

			

				nut.chat.send(client, "health", obs.self)

				client.lastThresh["heart"] = key

			end

			

			if((client.lastThresh["oxygen"] or 1000) > healthStatus.oxygen) then

				local obs, key = healthObs("oxygen", healthStatus.oxygen)

			

				nut.chat.send(client, "health", obs.self)

				client.lastThresh["oxygen"] = key

			end

		end

	end

	

	--checks the player's health stats and if they're low enough it'll kill them

	function PLUGIN:healthDeathCheck(client, healthStatus)

		if(healthStatus.blood == 0) then

			if(!client:getNetVar("dead")) then

				nut.chat.send(client, "health", "You have died from blood loss.")

				client:setNetVar("dead", true)

				

				if(!IsValid(client.nutRagdoll)) then

					client:setRagdolledI(true)

				end

				--client:Kill()

			end

		elseif(healthStatus.oxygen == 0) then

			if(!client:getNetVar("dead")) then

				nut.chat.send(client, "health", "You have died from oxygen deprivation.")

				client:setNetVar("dead", true)

				

				if(!IsValid(client.nutRagdoll)) then

					client:setRagdolledI(true)

				end

				--client:Kill()

			end

		elseif(healthStatus.heart == 0) then

			if(!client:getNetVar("dead")) then

				nut.chat.send(client, "health", "You have died from cardiac arrest.")

				client:setNetVar("dead", true)

				

				if(!IsValid(client.nutRagdoll)) then

					client:setRagdolledI(true)

				end

				--client:Kill()

			end

		end

	end

	

	local movement = {

		IN_FORWARD,

		IN_MOVELEFT,

		IN_MOVERIGHT,

		IN_BACK,

	}

	function PLUGIN:MovementCheck(client) --checks if the player is moving

		--turned off for now

		--[[

		for k, v in pairs(movement) do

			if(client:KeyDown(v)) then

				--finds the difference between player's movespeed and default movespeed

				local speedReduct = client:GetWalkSpeed() - nut.config.get("walkSpeed") 

				

				--this works assuming there's nothing else that reduces speed other than injuries, may need to be changed if that's not the case

				if(speedReduct < 0) then

					local roll = math.random(1, 100)

				

					if((speedReduct * -1) > roll) then

						client:setRagdolledI(true)

						nut.chat.send(client, "health", "You have fallen down due to your injuries.")

					end

				end

			end

		end

		--]]

	end

	

	function PLUGIN:CanPlayerUseChar(client, character, oldCharacter)

		if(client:getNetVar("uncon") or client:getNetVar("dead")) then

			return false, "@Injured"

		end

	end

end



--command that clears all of a target's injuries

nut.command.add("injuryclearall", {

	adminOnly = true,

	syntax = "<string target>",

	onRun = function(client, arguments)

		local target = nut.command.findPlayer(client, arguments[1])

		

		if(IsValid(target) and target:getChar()) then
			target:getChar():setData("injury", nil)
			target:resetHealthStatus()
			target:updateLoss()
			target:speedUpdate()
			client:notify(target:Name().. "'s injuries have been cleared.")

		else

			client:notify("Invalid target specified.")

		end

	end

})



--command that checks for injuries

nut.command.add("maskoff", {

	syntax = "<none>",

	onRun = function(client, arguments)

		local target = client:GetEyeTrace().Entity

		

		if(!IsValid(target) or !target:IsPlayer()) then

			target = client

		end

		

		if(target:getNetVar("mask")) then

			target:removePart("oxygen_mask")

			target:setNetVar("mask", nil)

			

			client:notify("Mask removed from " ..target:Name().. ".")

		else

			client:notify(target:Name().. " is not wearing a mask.")

		end

	end

})



--command that checks for injuries

nut.command.add("checkinjuries", {

	syntax = "<none>",

	onRun = function(client, arguments)

		local entity = client:GetEyeTrace().Entity

		

		if(IsValid(entity) and (entity:IsPlayer() or entity:getNetVar("player"))) then

			local target = entity:getNetVar("player", entity)

			

			local injuries = target:getInjuries()

			

			for part, injuryTbl in pairs(injuries) do

				local partString = PLUGIN.parts[part].name.. ": "

				for k, v in pairs(injuryTbl) do

					local injury = PLUGIN.injuries[k]

					partString = partString..injury.name.. " {" ..getSeverity(v).. "} "

				end

				

				nut.chat.send(client, "health", partString)

			end

			

			if(table.IsEmpty(injuries)) then

				nut.chat.send(client, "health", target:Name().. " is uninjured.")

			end

		else

			client:notify("Look at a valid target.")

		end

	end

})



--command that checks for injuries on self, mostly for debugging

nut.command.add("injuries", {

	syntax = "<none>",

	onRun = function(client, arguments)

		local injuries = client:getInjuries()

		

		for part, injuryTbl in pairs(injuries) do

			local partString = PLUGIN.parts[part].name.. ": "

			for k, v in pairs(injuryTbl) do

				local injury = PLUGIN.injuries[k]

				

				partString = partString..injury.name.. " {" ..getSeverity(v).. "}"

			end

			

			nut.chat.send(client, "health", partString)

		end

		

		if(table.IsEmpty(injuries)) then

			nut.chat.send(client, "health", client:Name().. " is uninjured.")

		end

	end

})



--checks blood levels

nut.command.add("checkblood", {

	syntax = "<none>",

	onRun = function(client, arguments)

		local entity = client:GetEyeTrace().Entity

		

		if(IsValid(entity) and (entity:IsPlayer() or entity:getNetVar("player"))) then

			local target = entity:getNetVar("player", entity)

			local healthStatus = target:getHealthStatus()

			

			nut.chat.send(client, "health", target:Name().. "'s " ..healthObs("blood", healthStatus.blood).obs)

		else

			client:notify("Look at a valid target.")

		end

	end

})



--checks oxygen levels

nut.command.add("checkairflow", {

	syntax = "<none>",

	onRun = function(client, arguments)

		local entity = client:GetEyeTrace().Entity

		

		if(IsValid(entity) and (entity:IsPlayer() or entity:getNetVar("player"))) then

			local target = entity:getNetVar("player", entity)

			local healthStatus = target:getHealthStatus()

			

			nut.chat.send(client, "health", target:Name().. "'s " ..healthObs("oxygen", healthStatus.oxygen).obs)

		else

			client:notify("Look at a valid target.")

		end

	end

})



--checks heart rate

nut.command.add("checkheart", {

	syntax = "<none>",

	onRun = function(client, arguments)

		local entity = client:GetEyeTrace().Entity

		

		if(IsValid(entity) and (entity:IsPlayer() or entity:getNetVar("player"))) then

			local target = entity:getNetVar("player", entity)

			local healthStatus = target:getHealthStatus()

			

			nut.chat.send(client, "health", target:Name().. "'s " ..healthObs("heart", healthStatus.heart).obs)

		else

			client:notify("Look at a valid target.")

		end

	end

})



--overwriting a default command

nut.command.add("chargetup", {

	onRun = function(client, arguments)

		local entity = client.nutRagdoll



		if (IsValid(entity) and entity.nutGrace and entity.nutGrace < CurTime() and entity:GetVelocity():Length2D() < 8 and !entity.nutWakingUp) then

			if(client:getNetVar("dead")) then

				entity.nutWakingUp = true

			

				client:setAction("Giving in...", 5, function()

					client:Kill()

				end)

			else

				entity.nutWakingUp = true

			

				client:setAction("Trying to wake up...", 15, function()

					if(client:getNetVar("dead")) then --if they died while trying to get up

						entity.nutWakingUp = nil 

						return

					end

					

					if(math.random(1,2) == 1) then --random chance to wake up or not

						if (!IsValid(entity)) then

							return

						end



						entity:Remove()

						

						client:setNetVar("uncon", nil)

					else

						entity.nutWakingUp = nil

					

						nut.chat.send(client, "health", "You failed to wake up.")

					end

				end)

			end

		end

	end

})



--chattype for the health printouts

nut.chat.register("health", {

	onChatAdd = function(speaker, text)

		chat.AddText(Color(200,75,75), text)

	end,

	filter = "actions",

	font = "nutChatFontHealth",

	onCanHear = 1,

	deadCanChat = true

})



if(CLIENT) then

	function PLUGIN:OnContextMenuOpen()

		LocalPlayer().cmenu = true

	end

		

	function PLUGIN:OnContextMenuClose()

		LocalPlayer().cmenu = nil

	end



	local owner, scrW, scrH, ceil, ft, clmp

	local dead, uncon

	ceil = math.ceil

	clmp = math.Clamp

	local aprg, aprg2 = 0, 0

	local scrW, scrH = ScrW(), ScrH()

	

	function PLUGIN:HUDPaint()

		owner = LocalPlayer()

		ft = FrameTime()



		dead = owner:getNetVar("dead")

		uncon = owner:getNetVar("uncon")

		if (owner:getChar()) then

			if (dead) then

				if (aprg2 != 1) then

					aprg = clmp(aprg + ft*.5, 0, 1)

					if (aprg == 1) then

						aprg2 = clmp(aprg2 + ft*.4, 0, 1)

					end

				end

				

				surface.SetDrawColor(0, 0, 0, ceil((aprg^.5) * 200))

				surface.DrawRect(-1, -1, scrW+2, scrH+2)

			elseif(uncon) then

				if (aprg2 != 1) then

					aprg = clmp(aprg + ft*.5, 0, 1)

					if (aprg == 1) then

						aprg2 = clmp(aprg2 + ft*.4, 0, 1)

					end

				end

				

				surface.SetDrawColor(0, 0, 0, ceil((aprg^.5) * 200))

				surface.DrawRect(-1, -1, scrW+2, scrH+2)

			else

				if (aprg != 0) then

					aprg2 = clmp(aprg2 - ft*1.3, 0, 1)

					if (aprg2 == 0) then

						aprg = clmp(aprg - ft*.7, 0, 1)

					end

				end

			end

		end



		if (aprg > 0.01 and dead) then

			surface.SetDrawColor(0, 0, 0, ceil((aprg^.5) * 255))

			surface.DrawRect(-1, -1, scrW+2, scrH+2)

			local tx, ty = nut.util.drawText("You are dead.", scrW/2, scrH/2, ColorAlpha(Color(200,200,200), aprg2 * 255), 1, 1, "nutDynFontMedium", aprg2 * 255)

			local tx, ty = nut.util.drawText("Press <Jump> to give in.", scrW/2, scrH/2 + 64, ColorAlpha(Color(200,200,200), aprg2 * 255), 1, 1, "nutToolTipText", aprg2 * 255)

			

			nut.bar.drawAll()

		elseif(aprg > 0.01 and uncon) then

			surface.SetDrawColor(0, 0, 0, ceil((aprg^.5) * 255))

			surface.DrawRect(-1, -1, scrW+2, scrH+2)

			local tx, ty = nut.util.drawText("You are unconscious.", scrW/2, scrH/2, ColorAlpha(Color(200,200,200), aprg2 * 255), 1, 1, "nutDynFontMedium", aprg2 * 255)

			local tx, ty = nut.util.drawText("Press <Jump> to try to wake up.", scrW/2, scrH/2 + 64, ColorAlpha(Color(200,200,200), aprg2 * 255), 1, 1, "nutToolTipText", aprg2 * 255)

			

			nut.bar.drawAll()

		end

			

		local localPlayer = owner

		

		if (!localPlayer.getChar(localPlayer)) then

			return

		end



		local realTime = RealTime()



		localPlayer.healthStatus = localPlayer.healthStatus

		if((localPlayer.nextHealth or 0) < realTime) then

			localPlayer.healthStatus = localPlayer:getHealthStatus()

			

			localPlayer.nextHealth = realTime + 2

		end

		

		--status bars

		if(localPlayer.healthStatus and (localPlayer:getNetVar("loss") or localPlayer.cmenu)) then

			--blood

			local x = scrW - 210

			local y = 80

			local w = 200

			local h = 16

			local color = Color(200,64,64)

			

			nut.util.drawBlurAt(x, y, w, h)



			surface.SetDrawColor(255, 255, 255, 15)

			surface.DrawRect(x, y, w, h)

			surface.DrawOutlinedRect(x, y, w, h)

			

			surface.SetFont("Default")

			surface.SetTextColor(255, 255, 255)

			surface.SetTextPos(x - surface.GetTextSize("Blood") - 4, y)

			surface.DrawText("Blood")



			x, y, w, h = x + 2, y + 2, (localPlayer.healthStatus.blood * 0.2), h - 4



			surface.SetDrawColor(color.r, color.g, color.b, 250)

			surface.DrawRect(x, y, w, h)



			surface.SetDrawColor(255, 255, 255, 8)

			--surface.SetMaterial(gradient)

			surface.DrawTexturedRect(x, y, w, h)

			

			--heartrate

			x = scrW - 210

			y = 80 + 24

			w = 200

			h = 16

			color = Color(64,200,64)

			

			nut.util.drawBlurAt(x, y, w, h)



			surface.SetDrawColor(255, 255, 255, 15)

			surface.DrawRect(x, y, w, h)

			surface.DrawOutlinedRect(x, y, w, h)

			

			surface.SetFont("Default")

			surface.SetTextColor(255, 255, 255)

			surface.SetTextPos(x - surface.GetTextSize("Heart") - 4, y)

			surface.DrawText("Heart")

			

			x, y, w, h = x + 2, y + 2, (localPlayer.healthStatus.heart * 0.2), h - 4



			surface.SetDrawColor(color.r, color.g, color.b, 250)

			surface.DrawRect(x, y, w, h)



			surface.SetDrawColor(255, 255, 255, 8)

			--surface.SetMaterial(gradient)

			surface.DrawTexturedRect(x, y, w, h)

			

			--oxygen

			x = scrW - 210

			y = 80 + 48

			w = 200

			h = 16

			color = Color(64,64,200)

			

			nut.util.drawBlurAt(x, y, w, h)



			surface.SetDrawColor(255, 255, 255, 15)

			surface.DrawRect(x, y, w, h)

			surface.DrawOutlinedRect(x, y, w, h)

			

			surface.SetFont("Default")

			surface.SetTextColor(255, 255, 255)

			surface.SetTextPos(x - surface.GetTextSize("Oxygen") - 4, y)

			surface.DrawText("Oxygen")



			x, y, w, h = x + 2, y + 2, (localPlayer.healthStatus.oxygen * 0.2), h - 4



			surface.SetDrawColor(color.r, color.g, color.b, 250)

			surface.DrawRect(x, y, w, h)



			surface.SetDrawColor(255, 255, 255, 8)

			--surface.SetMaterial(gradient)

			surface.DrawTexturedRect(x, y, w, h)	

		end

	end

	

	function PLUGIN:RenderScreenspaceEffects()

		local client = LocalPlayer()

		

		local loss = client:getNetVar("loss")

		if(loss) then

			local bleed = (loss.bleed or 0) * 0.01

			local oxyLoss = (loss.oxyLoss or 0) * 0.01

			

			local colorMod = {}

			colorMod["$pp_colour_addr"]           = 0

			colorMod["$pp_colour_addg"]           = 0

			colorMod["$pp_colour_addb"]           = 0

			colorMod["$pp_colour_brightness"]     = math.max(0 - (oxyLoss + bleed) * 0.5, -0.5)

			colorMod["$pp_colour_contrast"]       = 1

			colorMod["$pp_colour_colour"]         = math.max(1 - (bleed) * 0.5, 0.5)

			colorMod["$pp_colour_mulr"]           = 0

			colorMod["$pp_colour_mulg"]           = math.max(0 - bleed, -1)

			colorMod["$pp_colour_mulb"]           = math.max(0 - bleed, -1)



			DrawColorModify(colorMod) 

			

			DrawMotionBlur((bleed + oxyLoss) * 100, (bleed + oxyLoss) * 100, 0.01)

		end

		

		local oldInj = client:getNetVar("oldInj")

		if (oldInj) then

			DrawMotionBlur(0.4, 0.8, 0.01)

		end

	end



	--health font

	surface.CreateFont("nutChatFontHealth", {

		font = "Segoe UI",

		size = 30,

		extended = true,

		weight = 500,

		italic = true

	})

	

	netstream.Hook("nut_playsound", function(data)

		surface.PlaySound(data)

	end)

end