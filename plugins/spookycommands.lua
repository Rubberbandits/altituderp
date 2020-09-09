PLUGIN.name = "Spooky Commands"
PLUGIN.author = "Luna & Chancer & sky"
PLUGIN.desc = "Some commands that do spooky things to people, shortened and edited for SHATTERED."

nut.command.add("scwhisper", {
	adminOnly = true,
	syntax = "<string name>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1]) or client
		--local times = tonumber(arguments[2]) or 10
		local whispers = {}
		whispers[0] = "chorror/emily_reversed1.wav"
		whispers[1] = "chorror/emily_reversed3.wav"
		whispers[2] = "chorror/emily_reversed5.wav"
		whispers[3] = "chorror/emily_reversed9.wav"
		whispers[4] = "chorror/psstleft.wav"
		whispers[5] = "chorror/psstright.wav"
		whispers[6] = "shorror/kidwhisper.mp3"
		
		target:ConCommand( "play " .. whispers[math.random(0,6)] )
	end
})

nut.command.add("scemit", {
	adminOnly = true,
	syntax = "<string soundpath> <int soundlevel=70 (50-100)> <int pitch=100 (30-255)>",
	onRun = function(client, arguments)
	local soundLevel = tonumber(arguments[2] or 70)	
	local pitch = tonumber(arguments[3] or 100)
	if( pitch > 29 and pitch < 256  ) then
		client:EmitSound(arguments[1], soundLevel, pitch);
		client:notifyLocalized("Emitting a sound: " .. arguments[1] )
	else
		client:notifyLocalized("The pitch needs to be between 30 and 255!")
	end
	end
})

nut.command.add("scsound", {
	adminOnly = true,
	syntax = "<string name> <string soundpath>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1]) or client	
		target:ConCommand( "play " .. arguments[2] )		
	end
})