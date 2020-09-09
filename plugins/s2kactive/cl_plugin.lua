S2K = S2K or {}
S2K.Data = S2K.Data or {}

function S2K.Active()
	if (!S2K.Data.Active) then return false end
	if (!S2K.Data.Time || S2K.Data.Time == 0) then return true end
	if (S2K.Data.Time > os.time() + S2K.TimeOffset) then
		return S2K.Data.Time - os.time() + S2K.TimeOffset
	end

	return false
end

netstream.Hook("S2KMsg", function(...)
	chat.AddText(color_white, unpack({...}))
end)

netstream.Hook("S2KUpdate", function(data, servertime)
	S2K.Data = data
	S2K.TimeOffset = servertime - os.time()
end)

nut.command.add("s2kactive", {
	adminOnly = true,
	syntax = "<number active> [number time]",
	onRun = function(client, arguments)
	end
})

nut.command.add("pvp", {
	syntax = "",
	onRun = function(client, arguments)
	end
})