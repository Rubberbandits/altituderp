ITEM.name = "Morphine"

ITEM.desc = "A very effective and addictive painkiller."

ITEM.model = "models/illusion/eftcontainers/ibuprofen.mdl"

ITEM.width = 1

ITEM.height = 1

--ITEM.container = ""

ITEM.healAmount = 0

ITEM.healSeconds = 10

ITEM.flag = "v"

ITEM.category = "Medical"

ITEM.color = Color(232, 0, 0)

ITEM.quantity2 = 12



ITEM.functions.use = { -- sorry, for name order.

	name = "Use",

	tip = "useTip",

	icon = "icon16/add.png",

	onRun = function(item)

		local client = item.player

		if (client:Alive()) then

			client:getChar():setData("injurypost", nil)

		

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

					return true

				end

			end

			

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

				

			target:getChar():setData("injurypost", nil)

				

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

					return true

				end					

			end

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