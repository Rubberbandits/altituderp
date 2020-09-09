S2K = S2K or {}
S2K.Data = S2K.Data or {}

function S2K.Active()
	if (!S2K.Data.Active) then return false end
	if (!S2K.Data.Time || S2K.Data.Time == 0) then return true end
	if (S2K.Data.Time > os.time()) then
		return S2K.Data.Time - os.time()
	end

	return false
end

function S2K.Update(ply)
	netstream.Start(ply, "S2KUpdate", S2K.Data, os.time())
end

function S2K.UpdateAll()
	netstream.Start(nil, "S2KUpdate", S2K.Data, os.time())
end

function S2K.Set(value, time, silent)
	time = tonumber(time) or 0
	value = value == true or false
	S2K.Data = {
		Active = value,
		Time = time > 0 and os.time() + time or 0,
	}

	S2K.UpdateAll()

	if (!silent) then
		local msg
		local active = S2K.Active()
		if (active) then
			msg = "PvP has been enabled" .. (active == true and "!" or " for " .. string.NiceTime(math.floor(active)) .. "!")
		else
			msg = "PvP has been disabled!"
		end

		nut.util.notify(msg)
		netstream.Start(nil, "S2KMsg", msg)
	end
end

function PLUGIN:PlayerShouldTakeDamage( ply, attacker )
	if (!IsValid(ply) || (!IsValid(attacker) || !attacker:IsPlayer())) then return end
	if (!S2K.Active()) then
		if (!attacker.NoPvPWarn || SysTime() > attacker.NoPvPWarn) then
			attacker.NoPvPWarn = SysTime() + 5
			attacker:notify("PvP is currently disabled!")
			netstream.Start(attacker, "S2KMsg", "PvP is currently disabled!")
		end

		return false
	end
end

nut.command.add("pvp", {
	syntax = "",
	onRun = function(client, arguments)
		local active = S2K.Active()

		if (active) then
			if (active == true) then
				return "PvP is currently enabled!"
			else
				return "PvP is currently enabled! It will be disabled in " .. string.NiceTime(math.floor(active))
			end
		else
			return "PvP is currently disabled!"
		end
	end
})

nut.command.add("s2kactive", {
	adminOnly = true,
	syntax = "<number active> [number enableMinutes] [number silent]",
	onRun = function(client, arguments)
		local active = arguments[1]
		if (!active) then
			return "You must specify 'active' argument (values: 1 or 0)"
		end

		if (active != "1" && active != "0") then
			return "Active can only be 1 or 0"
		end

		active = active == "1"

		local arg2 = arguments[2]
		local arg2Number = tonumber(arg2)

		if (arg2 && (!arg2Number || arg2Number < 0)) then
			return "Minutes argument must be a number greater or equal to zero"
		end

		S2K.Set(active, (arg2Number or 0) * 60, arguments[3] and arguments[3] == "1")
		S2K.UpdateAll()
	end
})

function PLUGIN:LoadData()
	S2K.Data = self:getData()
	S2K.UpdateAll()
end

function PLUGIN:SaveData()
	self:setData(S2K.Data)
end

function PLUGIN:PlayerInitialSpawn(ply)
	S2K.Update(ply)
end