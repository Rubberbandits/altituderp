ITEM.name = "Medical Base"

ITEM.model = "models/healthvial.mdl"

ITEM.width = 1

ITEM.height = 1

ITEM.desc = "A medical item."

ITEM.healAmount = 50

ITEM.healSeconds = 10

ITEM.flag = "v"

ITEM.category = "Medical"

ITEM.color = Color(232, 0, 0)

ITEM.quantity2 = 1



--ITEM.useTime = 5

--ITEM.useText = ""



--ITEM.targetOnly = true



--ITEM.restore = {}

--ITEM.injFix = {}



local function onUse(client)

	--client:EmitSound("items/medshot4.wav", 80, 110)

	--client:ScreenFade(1, Color(0, 255, 0, 100), .4, 0)

end



local function healPlayer(client, target, amount, seconds)

	hook.Run("OnPlayerHeal", client, target, amount, seconds)



	if (client:Alive() and target:Alive()) then

		local id = "nutHeal_"..FrameTime()

		timer.Create(id, 1, seconds, function()

			if (!target:IsValid() or !target:Alive()) then

				timer.Destroy(id)	

			end



			target:SetHealth(math.Clamp(target:Health() + (amount/seconds), 0, target:GetMaxHealth()))

		end)

		

		onUse(target)

	end

end



ITEM.functions.use = { -- sorry, for name order.

	name = "Use",

	tip = "useTip",

	icon = "icon16/add.png",

	onRun = function(item)

		local client = item.player

		if (client:Alive()) then

			if(item.useText) then

				nut.chat.send(client, "me", item.useText.. " " .. " themselves.")

			end



			client:Freeze(true)

			

			if(item.useSound) then

				client:EmitSound(item.useSound)

			end

			

			client:setAction("Applying " ..item.name.. "..." , item.useTime or 0, function()

				client:Freeze(false)

				

				healPlayer(client, client, item.healAmount, item.healSeconds)

				

				if(item.injFix) then

					local repair = table.Copy(item.injFix) --the amount of "fixing" it will do

				

					local injuries = client:getChar():getData("injury", {})

					

					for part, injuryTbl in pairs(injuries) do

						for injuryType, injury in pairs(injuryTbl) do

							if(repair[injuryType]) then

								client:removeInjury(part, injuryType, repair[injuryType]) --removes the injury or a part of the injury

								repair[injuryType] = math.max(repair[injuryType] - injury, 0) --reduce the remaining "fixing" value on the item so it can be applied on other injuries

							end

						end

					end

					

					client:getChar():setData("injury", injuries)

					

					client:updateLoss()

					client:speedUpdate()

					

					client:getChar():setData("injuryPost", true)

				end

				

				if(item.restore) then

					for k, v in pairs(item.restore) do

						client:addHealthStatus(k, v)

					end

				end

				

				if(item.useText) then

					nut.chat.send(client, "me", "finishes applying " ..item.name.. ".")

				end

				

				local quantity2 = item:getData("quantity2", item.quantity2)

				if(tonumber(quantity2) > 1) then

					item:setData("quantity2", quantity2 - 1)

					return false

				else

					if(item.container) then

						local position = client:getItemDropPos()

						nut.item.spawn(item.container, position)

					end

					

					if(item.charges) then

						return false

					else

						item:remove()

					end

				end

			end)

			

			return false

		end

	end,

	onCanRun = function(item)

		if(item.targetOnly) then

			return false

		end

		

		local quantity2 = item:getData("quantity2", item.quantity2 or 1)

		if(quantity2 <= 0) then

			return false

		end

		

		return true

    end

}



ITEM.functions.usef = { -- sorry, for name order.

	name = "Use Forward",

	tip = "useTip",

	icon = "icon16/arrow_up.png",

	onRun = function(item)

		local client = item.player

		local position = client:getItemDropPos()

		local trace = client:GetEyeTraceNoCursor() -- We don't need cursors.

		local target = trace.Entity



		if (IsValid(target) and (target:IsPlayer() or target:getNetVar("player"))) then

			target = target:getNetVar("player", target) --makes it so we can do this to ragdolled people too

		

			if(item.useText) then

				nut.chat.send(client, "me", item.useText.. " " ..target:Name().. ".")

			end

			

			if(item.useSound) then

				client:EmitSound(item.useSound)

			end

			

			client:Freeze(true)

			client:setAction("Applying " ..item.name.. "..." , item.useTime or 0, function()

				client:Freeze(false)		



				healPlayer(client, target, item.healAmount, item.healSeconds)



				if(item.injFix) then

					local repair = table.Copy(item.injFix) --the amount of "fixing" it will do

				

					local injuries = target:getChar():getData("injury", {})

					

					for part, injuryTbl in pairs(injuries) do

						for injuryType, injury in pairs(injuryTbl) do

							if(repair[injuryType]) then

								target:removeInjury(part, injuryType, repair[injuryType]) --removes the injury or a part of the injury

								repair[injuryType] = math.max(repair[injuryType] - injury, 0) --reduce the remaining "fixing" value on the item so it can be applied on other injuries

							end

						end

					end

					

					target:getChar():setData("injury", injuries)

					

					target:updateLoss()

					target:speedUpdate()

					

					client:getChar():setData("injuryPost", true)

				end

				

				if(item.restore) then

					for k, v in pairs(item.restore) do

						target:addHealthStatus(k, v)

					end

				end

				

				if(item.useText) then

					nut.chat.send(client, "me", "finishes applying " ..item.name.. ".")

				end

				

				local quantity2 = item:getData("quantity2", item.quantity2 or 1)

				if(tonumber(quantity2) > 1) then

					item:setData("quantity2", quantity2 - 1)

					return false

				else

					if(item.container) then

						nut.item.spawn(item.container, position)

					end

					

					if(item.charges) then

						return false

					else

						item:remove()

					end

				end

			end)

		end



		return false

	end,

	onCanRun = function(item)

		local quantity2 = item:getData("quantity2", item.quantity2 or 1)

		if(quantity2 <= 0) then

			return false

		end

	

		if(IsValid(item.entity)) then

			return false

		end

	

		return true

	end

}



--restores the charges to the item if the appropriate item is available

ITEM.functions.restore = {

	name = "Restore",

	tip = "useTip",

	icon = "icon16/add.png",

	sound = "items/battery_pickup.wav",

	onRun = function(item)

		local client = item.player

		local char = client:getChar()

		local inventory = char:getInv()

		

		--the first function is for 1.1 beta, just a compatibility thing

		local chargeReq = (inventory.getFirstItemOfType and inventory:getFirstItemOfType(item.chargeReq)) or inventory:hasItem(item.chargeReq)

		

		if(chargeReq) then

			chargeReq:remove()

			item:setData("quantity2", item.quantity2 or 1)

		end

		

		return false

	end,

	onCanRun = function(item)

		if(item.charges) then

			local client = item.player

			local char = client:getChar()

			local inventory = char:getInv()

			if(inventory:hasItem(item.chargeReq)) then

				return true

			else

				return false

			end

		else

			return false

		end

    end

}



function ITEM:getDesc(partial)

	local desc = self.desc

	

	if(!partial) then

		if(self:getData("quantity2", self.quantity2) != nil) then

			desc = desc.. "\nRemaining Uses: " ..self:getData("quantity2", self.quantity2)

		end

	end

	

	return Format(desc)

end



function ITEM:getName()

	local name = self.name

	

	return Format(name)

end



if (CLIENT) then

	function ITEM:paintOver(item, w, h)

		local quantity2 = item:getData("quantity2", item.quantity2)



		if (tonumber(quantity2) > 1) then

			draw.SimpleText(quantity2, "DermaDefault", w - 12, h - 14, Color(255,50,50), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)

		end

	end

end