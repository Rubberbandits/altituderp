ITEM.name = "Repairable Armor"
ITEM.desc = "An equippable item that can be repaired"
ITEM.model = "models/Items/grenadeAmmo.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Armor"
ITEM.sound = "items/battery_pickup.wav"
ITEM.armor = 0
ITEM.slot = "Miscellaneous"

function ITEM:removeOutfit(client)
	local character = client:getChar()
	
	self:setData("equip", nil)

	if (character:getData("oldMdl")) then
		character:setModel(character:getData("oldMdl"))
		character:setData("oldMdl", nil)
	end
	
	if (self.newSkin) then
		if (character:getData("oldSkin")) then
			client:SetSkin(character:getData("oldSkin"))
			character:setData("oldSkin", nil)
		else
			client:SetSkin(0)
		end
	end

	for k, v in pairs(self.bodyGroups or {}) do
		local index = client:FindBodygroupByName(k)

		if (index > -1) then
			client:SetBodygroup(index, 0)

			local groups = character:getData("groups", {})

			if (groups[index]) then
				groups[index] = nil
				character:setData("groups", groups)
			end
		end
	end
	
	if (client.removePart) then
		client:removePart(self.uniqueID)
	end
end

-- On player eqipped the item, Gives a weapon to player and load the ammo data from the item.
ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	onRun = function(item)
		local client = item.player
		
		local items = client:getChar():getInv():getItems()
		for k, v in pairs(items) do
			if (v.id != item.id) then
				if (
					v:getData("equip") and
					v.slot == item.slot
			 	) then
					client:notify(item.slot.. " slot already filled.")
					return false
				end
			end
		end
		
		if (client.addPart) then
			client:addPart(item.uniqueID)
		end
		
		if (type(item.onGetReplacement) == "function") then
			char:setData("oldMdl", char:getData("oldMdl", item.player:GetModel()))
			char:setModel(item:onGetReplacement())
		elseif (item.replacement or item.replacements) then
			char:setData("oldMdl", char:getData("oldMdl", item.player:GetModel()))

			if (type(item.replacements) == "table") then
				if (#item.replacements == 2 and type(item.replacements[1]) == "string") then
					char:setModel(item.player:GetModel():gsub(item.replacements[1], item.replacements[2]))
				else
					for k, v in ipairs(item.replacements) do
						char:setModel(item.player:GetModel():gsub(v[1], v[2]))
					end
				end
			else
				char:setModel(item.replacement or item.replacements)
			end
		end
		
		if (item.newSkin) then
			char:setData("oldSkin", item.player:GetSkin())
			item.player:SetSkin(item.newSkin)
		end
		
		if (item.bodyGroups) then
			local groups = {}

			for k, value in pairs(item.bodyGroups) do
				local index = item.player:FindBodygroupByName(k)

				if (index > -1) then
					groups[index] = value
				end
			end

			local newGroups = char:getData("groups", {})

			for index, value in pairs(groups) do
				newGroups[index] = value
				item.player:SetBodygroup(index, value)
			end

			if (table.Count(newGroups) > 0) then
				char:setData("groups", newGroups)
			end
		end
		
		item:setData("equip", true)
	
		client:EmitSound(item.sound)
	
		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity) and item:getData("equip") != true)
	end
}

-- On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/cross.png",
	onRun = function(item)
		local client = item.player
	
		item:removeOutfit(client)
		
		item:setData("equip", nil)
		
		return false
	end,
	onCanRun = function(item)	
		return (!IsValid(item.entity) and item:getData("equip") == true)
	end
}

-- On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.Repair = { -- sorry, for name order.
	name = "Repair",
	icon = "icon16/wrench.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		local inventory = char:getInv()
		
		local repairKit = inventory:getFirstItemOfType("armor_repair") --for ns 1.1 beta
		--local repairKit = inventory:hasItem("armor_repair") --for regular 1.1
		if(repairKit) then
			repairKit:remove()
			item:setData("dura", item.dura)
		else
			client:notify("You do not have an armor repair kit.")
		end

		return false
	end,
	onCanRun = function(item)	
		return (!IsValid(item.entity) and !item:getData("equip"))
	end
}

-- On item is dropped, Remove a weapon from the player and keep the ammo in the item.
ITEM:hook("drop", function(item)
	if (item:getData("equip")) then
		local client = item.player
	
		item:setData("equip", nil)
		
		item:removeOutfit(item.player)
	end
end)

function ITEM:onCanBeTransfered(oldInventory, newInventory)
	if (newInventory and self:getData("equip")) then
		return false
	end

	return true
end

function ITEM:onRemoved()
	local inv = nut.item.inventories[self.invID]
	local receiver = inv.getReceiver and inv:getReceiver()

	if (IsValid(receiver) and receiver:IsPlayer()) then
		if (self:getData("equip")) then
			self:removeOutfit(receiver)
		end
	end
end

function ITEM:getDesc()
	local desc = self.desc
	
	local dura = self:getData("dura", self.dura) or 100
	local maxDura = self.dura or 100
	
	local percent = math.max(math.Round(dura/maxDura * 100, 0), 0)
	
	desc = desc.. "\nDurability: " ..percent.. "%."
	
	return desc
end

-- Inventory drawing
if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		if (item:getData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end