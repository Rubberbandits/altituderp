nut.command.add("roll", {
	syntax = "[number maximum]",
	onRun = function(client, arguments)
		local rolled = math.random(0, math.min(tonumber(arguments[1]) or 100, 100))
		nut.log.add(client:Name().." rolled \""..rolled.."\"")	
		nut.chat.send(client, "roll", rolled)
	end
})

nut.command.add("fallover", {
	syntax = "[number time]",
	onRun = function(client, arguments)
		local time = tonumber(arguments[1])

		if (time and !isnumber(time)) then
			time = 5
		end

		if (time and time > 0) then
			time = math.Clamp(time, 1, 60)
		else
			time = nil
		end

		if (!IsValid(client.nutRagdoll)) then
			client:setRagdolled(true, time)
		end
	end
})

nut.command.add("chargiveitem", {
	adminOnly = true,
	syntax = "<string name> <string item> <integer amount>",
	onRun = function(client, arguments)
		if (!arguments[2]) then
			return L("invalidArg", client, 2)
		end

		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) and target:getChar()) then
			local uniqueID = arguments[2]:lower()
			local amount = tonumber(arguments[3])

			if (!nut.item.list[uniqueID]) then
				for k, v in SortedPairs(nut.item.list) do
					if (nut.util.stringMatches(v.name, uniqueID)) then
						uniqueID = k

						break
					end
				end
			end

			if (arguments[3] and arguments[3] != "") then
				if (!amount) then
					return L("invalidArg", client, 3)
				end
			end

			local notified
			for i = 1, (amount or 1) do
				target:getChar():getInv():add(uniqueID)
					:next(function(res)
						if(!notified) then
							if (IsValid(target)) then
								target:notifyLocalized("itemCreated", nut.item.list[uniqueID].name, target:Name())
							end
							
							if (IsValid(client) and client ~= target) then
								client:notifyLocalized("itemCreated", nut.item.list[uniqueID].name, target:Name())
							end
							
							notified = true
						end
					end)
					:catch(function(err)
						if (IsValid(client)) then
							client:notifyLocalized(err)
						end
					end)
			end
		end
	end
})

nut.command.add("givemoney", {
	syntax = "<number amount>",
	onRun = function(client, arguments)
		local number = tonumber(arguments[1])
		number = number or 0
		local amount = math.floor(number)

		if (!amount or !isnumber(amount) or amount <= 0) then
			return L("invalidArg", client, 1)
		end

		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:IsPlayer() and target:getChar()) then
			amount = math.Round(amount)

			if (!client:getChar():hasMoney(amount)) then
				return
			end

			target:getChar():giveMoney(amount)
			client:getChar():takeMoney(amount)

			target:notifyLocalized("moneyTaken", nut.currency.get(amount))
			client:notifyLocalized("moneyGiven", nut.currency.get(amount))

			client:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
		end
	end
})