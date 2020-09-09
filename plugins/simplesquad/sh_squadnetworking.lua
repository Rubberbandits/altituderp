--[[ NETWORKING ]] --

--[[
	NOTE: I know that this isn't the most effective way to network. There's a lot
	of unnecessary Network Strings that could have been simplified down. I plan on returning
	here to redo and redocument the networking.
]]

if SERVER then
	util.AddNetworkString("createSquad")
	util.AddNetworkString("joinSquad")
	util.AddNetworkString("manageSquad")
	util.AddNetworkString("squadKick")
	util.AddNetworkString("squadPromote")
	util.AddNetworkString("squadSync")

	net.Receive( "createSquad", function( len, pl )
		local tab = net.ReadTable()

		nut.squadsystem.createSquad(tab[1], tab[2])
	end )

	net.Receive( "joinSquad", function( len, pl )
		local tab = net.ReadTable()

		nut.squadsystem.joinSquad(tab[1], tab[2])
	end)

	net.Receive("squadKick", function()
		local tab = net.ReadTable()
		local client = tab[1]

		nut.squadsystem.leaveSquad(client)
	end)

	net.Receive("squadPromote", function()
		local tab = net.ReadTable()
		local client = tab[1]

		nut.squadsystem.setSquadLeader(client)
	end)

	net.Receive("squadSync", function()
		squad = net.ReadTable()
	end)
else
	squad = squad or {}

	nut.squadsystem.squads = nut.squadsystem.squads or {}

	net.Receive( "createSquad", function()
		vgui.Create("nutSquadCreate")
	end)

	net.Receive( "manageSquad", function()
		vgui.Create("nutSquadManage")
	end)

	net.Receive( "joinSquad", function()
		nut.squadsystem.squads = net.ReadTable()
		vgui.Create("nutSquadJoin")
	end)

	net.Receive("squadSync", function()
		squad = net.ReadTable()
	end)
end