function SCHEMA:OnCharCreated(client, character)
	local inventory = character:getInv()

	if (inventory) then		
		local items = {}
	
		if (character:getFaction() == FACTION_CITIZENS) then
			items = {
				"radio","cw_ar15","att_foregrip","att_shortrec","cw_p99"
			}
		elseif (character:getFaction() == FACTION_SURVIVOR) then

		elseif (character:getFaction() == FACTION_PLASTIC) then
			items = {
				"book_newchar_plastic"
			}

			timer.Simple(0.5, function()
				local traitData = character:getData("traits", {})
				traitData["pla"] = 1
				character:setData("traits", traitData, false, player.GetAll())
			end)
		elseif (character:getFaction() == FACTION_ABER) then
			items = {
				"food_banana"
			}
		end
		
		local i = 20
		for k, v in pairs(items) do
			timer.Simple(i + k, function()
				inventory:add(v)
			end)
		end
	end
end 

function SCHEMA:PrePlayerLoadedChar(client, character, currentChar)
	if (character:getFaction() == FACTION_PLASTIC) then --material for plastic faction
		client:SetMaterial("phoenix_storms/mrref2")
	else
		client:SetMaterial("") --necessary for char swapping from plastic to anything else
	end
end

--if players can spawn effect props or not
function SCHEMA:PlayerSpawnEffect(client, weapon, info)
	return client:IsAdmin() or client:getChar():hasFlags("E")
end

--turns off sprays
function SCHEMA:PlayerSpray(client)
    return true
end

function SCHEMA:Initialize()
	--game.ConsoleCommand("net_maxfilesize 64\n");
	game.ConsoleCommand("sv_kickerrornum 0\n");

	game.ConsoleCommand("sv_allowupload 0\n");
	game.ConsoleCommand("sv_allowdownload 0\n");
	game.ConsoleCommand("sv_allowcslua 0\n");
end

function SCHEMA:PostPlayerLoadout(client)
	-- Reload All Attrib Boosts
	local char = client:getChar()

	if (char:getInv()) then
		for k, v in pairs(char:getInv():getItems()) do
			v:call("onLoadout", client)

			if (v:getData("equip", false) and (v.attribBoosts or v:getData("attrib", nil))) then
				--[[
				local temp = {}
				--combines both boost lists
				local customBoosts = v:getData("attrib", {})
				for k2, v2 in pairs(v.attribBoosts or {}) do
					temp[k2] = v2
				end
				
				for k2, v2 in pairs(customBoosts) do
					temp[k2] = (temp[k2] or 0) + v2
				end
			
				for k2, v2 in pairs(temp) do
					char:addBoost(v.uniqueID, k2, v2)
				end
				--]]
				
				timer.Simple(1, function()
					if(v.buffRefresh) then
						v.buffRefresh(v, client)
					end

					--PrintTable(itemTable)
				end)
			end
		end
	end
end

function SCHEMA:PlayerSpawnRagdoll(client)
	if(client and client:IsPlayer()) then
		if (client:getChar() and client:getChar():hasFlags("r")) then
			return true
		end

		return false
	end
end

--someone gave me this but I don't think it does anything the way it is now
function SCHEMA:Think()
	if((self.NextDBRefresh or 0) < CurTime()) then
		nut.db.query("SELECT 1 + 1", onSuccess)
			
		self.NextDBRefresh = CurTime() + 10
	end
end

netstream.Hook("strReq", function(client, time, text)
	if (client.nutStrReqs and client.nutStrReqs[time]) then
		client.nutStrReqs[time](text)
		client.nutStrReqs[time] = nil
	end
end)

local ITEM = nut.meta.item
function ITEM:interact(action, client, entity, data)
	assert(
		type(client) == "Player" and IsValid(client),
		"Item action cannot be performed without a player"
	)

	local canInteract, reason =
		hook.Run("CanPlayerInteractItem", client, action, self, data)
	if (canInteract == false) then
		if (reason) then 
			client:notifyLocalized(reason)
		end

		return false
	end

	local oldPlayer, oldEntity = self.player, self.entity

	self.player = client
	self.entity = entity

	local callback = self.functions[action] or self.functionsD[action] or self.functionsB[action]
	if (not callback) then
		self.player = oldPlayer
		self.entity = oldEntity
		return false
	end

	canInteract = isfunction(callback.onCanRun)
		and not callback.onCanRun(self, data)
		or true
	if (not canInteract) then
		self.player = oldPlayer
		self.entity = oldEntity
		return false
	end

	local result
	-- TODO: better solution for hooking onto these - something like mixins?
	if (isfunction(self.hooks[action])) then
		result = self.hooks[action](self, data)
	end
	if (result == nil and isfunction(callback.onRun)) then
		result = callback.onRun(self, data)
	end
	if (self.postHooks[action]) then
		-- Posthooks shouldn't override the result from onRun
		self.postHooks[action](self, result, data)
	end
	hook.Run("OnPlayerInteractItem", client, action, self, result, data)

	if (result ~= false and not deferred.isPromise(result)) then
		if (IsValid(entity)) then
			entity:Remove()
		else
			self:remove()
		end
	end

	self.player = oldPlayer
	self.entity = oldEntity
	return true
end