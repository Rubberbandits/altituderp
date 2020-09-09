ITEM.name = "Squad Identification Device"
ITEM.desc = "A device that allows for easy identification of squad members."
ITEM.model = "models/Items/battery.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Utility"
ITEM.flag = "v"
ITEM.functions.create = {
    name = "Create Squad",
    icon = "icon16/asterisk_yellow.png",
    onRun = function(item, data)
        net.Start("createSquad")
        net.Send(item.player)
        return false
    end
}
ITEM.functions.join = {
	name = "Join Squad",
	icon = "icon16/add.png",
	onRun = function(item, data)
		net.Start("joinSquad")
            net.WriteTable(nut.squadsystem.squads)
        net.Send(item.player)
		return false
	end
}
ITEM.functions.manage = {
    name = "Manage Squad",
    icon = "icon16/wrench.png",
    onRun = function(item, data)
        local char = item.player:getChar()
        local squadName = char:getSquad() or nil
        local squad = nut.squadsystem.squads[squadName] or nil
        if (squad) and (squad[1].member == item.player) then
            net.Start("manageSquad")
            net.Send(item.player)
        else
            item.player:notify("You are not a squad leader.")
        end
        return false
    end
}
ITEM.functions.leave = {
    name = "Leave Squad",
    icon = "icon16/delete.png",
    onRun = function(item, data)
        nut.squadsystem.leaveSquad(item.player)
        return false
    end
}
ITEM.functions.setcolor = {
    name = "Set Color",
    icon = "icon16/color_wheel.png",
    isMulti = true,
    multiOptions = function(item, ply)
        options = {
            {
                name = "Red",
                data = {
                    color = "red"
                }
            },
            {
                name = "Blue",
                data = {
                    color = "blue"
                }
            },
            {
                name = "Green",
                data = {
                    color = "green"
                }
            },
            {
                name = "Yellow",
                data = {
                    color = "yellow"
                }
            },
            {
                name = "White",
                data = {
                    color = "white"
                }
            }
        }

        return options
    end,
    onRun = function(item, data)
        item.player:getChar():setSquadColor(data.color)
        return false
    end
}