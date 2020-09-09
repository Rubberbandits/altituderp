local PLUGIN = PLUGIN
PLUGIN.name = "Credit Transference"
PLUGIN.author = "Westford"
PLUGIN.desc = "A plugin designed to allow users to transfer credits to and from one another, digitally, in lieu of physical credit chits."

nut.command.add("transfercredits", {
	syntax = "<string target> <number amount>",
	onRun = function(client, arguments)
		local amount = tonumber(arguments[2])

		if (!amount or !isnumber(amount) or amount < 0) then
			return "@invalidArg", 2
		end

		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) and target:IsPlayer() and target:getChar()) then
			local char = target:getChar()
			
			if (char and amount) then

				amount = math.Round(amount)

				if (!client:getChar():hasMoney(amount)) then
					return
				end

				
				target:getChar():giveMoney(amount)
				client:getChar():takeMoney(amount)

				target:notifyLocalized("moneyTaken", nut.currency.get(amount))
				client:notifyLocalized("moneyGiven", nut.currency.get(amount))
			end
		end
	end
})