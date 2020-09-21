PLUGIN.name = "Item Forge"
PLUGIN.author = "Killing Torcher"
PLUGIN.desc = "Allows creating custom items in-game"


--function nut.item.register(uniqueID, baseID, isBaseItem, path, luaGenerated)

KTItems = KTItems or {}
KTItems.List = KTItems.List or {}



function KTItems.RegisterCustomItem(id, itemData)
	if (!id) then return end
	
	local ITEM = nut.item.register(id, nil, false, nil, true)
	if (ITEM) then
		for k,v in pairs(itemData) do
			ITEM[k] = v
		end
		
		if (itemData.restore) then
			ITEM.functions.Use = {
				onRun = function(item)
					item.player:SetHealth(math.min(item.player:Health() + item.restore, 100))
					item.player:setLocalVar("stm", math.min(item.player:getLocalVar("stm", 100) + item.restore, 100))
				end
			}
		end
		
		--print("[KTItems]: Registered custom item '" .. id .. "'")
	end
end

nut.command.add("itemforge", {
	adminOnly = true,
	syntax = "",
	onRun = function(client, arguments)
		if (!client:IsAdmin()) then return end
		
		netstream.Start(client, "itemForgeGUI")
	end
})

nut.command.add("itemforgelist", {
	adminOnly = true,
	syntax = "",
	onRun = function(client, arguments)
		if (!client:IsAdmin()) then return end

		netstream.Start(client, "itemForgeList", KTItems.List) 
	end
})

nut.command.add("itemforgedetails", {
	adminOnly = true,
	syntax = "<uniqueID>",
	onRun = function(client, arguments)
		if (!client:IsAdmin()) then return end
		
		local uniqueID = arguments[1]
		if (!uniqueID || !KTItems.List[uniqueID]) then
			client:notify("Unique ID is invalid. Consider using /itemforgelist")
			return
		end
		
		netstream.Start(client, "itemForgeDetails", uniqueID, KTItems.List[uniqueID]) 
	end
})

nut.command.add("itemforgedelete", {
	adminOnly = true,
	syntax = "<uniqueID>",
	onRun = function(client, arguments)
		if (!client:IsAdmin()) then return end
		
		local uniqueID = arguments[1]
		if (!uniqueID) then
			client:notify("You have to specify a unique ID")
			return
		end
		
		if (!KTItems.List[uniqueID]) then
			client:notify("That is not an item-forge generated item ID.")
			return
		end
		
		KTItems.List[uniqueID] = nil
		local count = 0
		for k,v in pairs(nut.item.instances) do
			if (v && istable(v) && v.uniqueID && v.uniqueID == uniqueID) then
				count = count + 1
				v:remove()
			end
		end
		
		nut.item.list[uniqueID] = nil
		client:notify("Removed " .. count .. " instances of " .. uniqueID .. " in the world & removed item type!")
		
		netstream.Start(nil, "itemForgeDelete", uniqueID) 
	end
})

if (SERVER) then

else
	netstream.Hook("KTItemsLoad", function(items)
		KTItems.List = items
		
		
		for uniqueID, itemData in pairs(KTItems.List) do
			KTItems.RegisterCustomItem(uniqueID, itemData)
		end
	end)
	
	netstream.Hook("KTItemsLoadSingle", function(id, itemData)
		KTItems.List[id] = item
		
		KTItems.RegisterCustomItem(id, itemData)
	end)
	
	netstream.Hook("itemForgeGUI", function()
		local panel = vgui.Create("DFrame")
		panel:SetSize(500, 225)
		panel:SetTitle("KT's Item Forge")
		panel:Center()
		panel:MakePopup()
		
		local size_offset = 0
		
		local label1 = vgui.Create("DLabel", panel)
		label1:SetPos(5, 30 + size_offset)
		label1:SetText("Unique ID:")
		label1:SizeToContents()
		size_offset = size_offset + 25
		
		local txtUniqueID = vgui.Create("DTextEntry", panel)
		txtUniqueID:SetPos(105, 26 + size_offset - 25)
		txtUniqueID:SetSize(390, 20)
		txtUniqueID:SetTooltip("This is the item's Unique ID. Every item needs a different one. Example: water_bottle_fiji")
		
		local label1 = vgui.Create("DLabel", panel)
		label1:SetPos(5, 30 + size_offset)
		label1:SetText("Item Name:")
		label1:SizeToContents()
		size_offset = size_offset + 25
		
		local txtName = vgui.Create("DTextEntry", panel)
		txtName:SetPos(105, 26 + size_offset - 25)
		txtName:SetSize(390, 20)
		
		local label1 = vgui.Create("DLabel", panel)
		label1:SetPos(5, 30 + size_offset)
		label1:SetText("Item Description:")
		label1:SizeToContents()
		size_offset = size_offset + 25
		
		local txtDesc = vgui.Create("DTextEntry", panel)
		txtDesc:SetPos(105, 26 + size_offset - 25)
		txtDesc:SetSize(390, 20)
		
		local label1 = vgui.Create("DLabel", panel)
		label1:SetPos(5, 30 + size_offset)
		label1:SetText("Item Model:")
		label1:SizeToContents()
		size_offset = size_offset + 25
		
		local txtModel = vgui.Create("DTextEntry", panel)
		txtModel:SetPos(105, 26 + size_offset - 25)
		txtModel:SetSize(390, 20)
		
		local label1 = vgui.Create("DLabel", panel)
		label1:SetPos(5, 30 + size_offset)
		label1:SetText("Item Category:")
		label1:SizeToContents()
		size_offset = size_offset + 25
		
		local txtCategory = vgui.Create("DTextEntry", panel)
		txtCategory:SetPos(105, 26 + size_offset - 25)
		txtCategory:SetSize(390, 20)
		
		local label1 = vgui.Create("DLabel", panel)
		label1:SetPos(5, 30 + size_offset)
		label1:SetText("Item Price:")
		label1:SizeToContents()
		size_offset = size_offset + 25
		
		local txtPrice = vgui.Create("DTextEntry", panel)
		txtPrice:SetPos(105, 26 + size_offset - 25)
		txtPrice:SetSize(390, 20)
		
		local label1 = vgui.Create("DLabel", panel)
		label1:SetPos(5, 30 + size_offset)
		label1:SetText("Restore Amount:")
		label1:SizeToContents()
		size_offset = size_offset + 25
		
		local txtRestore = vgui.Create("DTextEntry", panel)
		txtRestore:SetPos(105, 26 + size_offset - 25)
		txtRestore:SetSize(390, 20)
		txtRestore:SetTooltip("Leave empty or set to 0 if you do not wish the item to be consumable.")
		
		local submitButton = vgui.Create("DButton", panel)
		submitButton:SetPos(5, 26 + size_offset)
		submitButton:SetSize(490, 20)
		submitButton:SetText("Create/Update Item")
		submitButton:SetSkin("Default")
		submitButton.DoClick = function()
			for k,v in pairs ({txtUniqueID, txtName, txtDesc, txtModel}) do
				if (!v:GetValue() || type(v:GetValue()) != "string" || v:GetValue() == "") then
					nut.util.notify("You have to specify a Unique ID, Name, Description and Model")
					return
				end
			end
			local itemData = {name = txtName:GetValue(), desc = txtDesc:GetValue(), model = txtModel:GetValue()}
			
			if (txtCategory:GetValue() && txtCategory:GetValue() != "") then
				itemData.category = txtCategory:GetValue()
			end

			itemData.price = tonumber(txtPrice:GetValue())
			local restore = tonumber(txtRestore:GetValue()) 
			if (restore && restore > 0) then
				itemData.restore = restore
			end
			
			netstream.Start("itemForgeGUI", txtUniqueID:GetValue(), itemData)
		end
	end)
	
	netstream.Hook("itemForgeDetails", function(uniqueID, items)
		print("Item table for custom item " .. uniqueID)
		PrintTable(items)
		
		chat.AddText(color_white, "Details have been printed to your console.")
	end)
	
	netstream.Hook("itemForgeList", function(items)
		for k,v in pairs(items) do
			print(k .. " = " .. v.name)
		end
		
		chat.AddText(color_white, "A list of all custom item forge items has been printed to your console. Use /itemforgedetails <uniqueID> for details.")
	end)
end