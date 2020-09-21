local PLUGIN = PLUGIN
PLUGIN.name = "Screenspace Effects/Displays"
PLUGIN.desc = "Make stuff appear on players' screens."
PLUGIN.author = "rusty"

if !evolve then
    FindMetaTable("Player").EV_HasPrivilege = function(client) return true end -- dev
end

function PLUGIN:PluginInitialized()
    if nut.evolve then
        nut.evolve:AddPrivilege("screenfadeblack")
        nut.evolve:AddPrivilege("screenfadewhite")
        nut.evolve:AddPrivilege("screenfaderemove")
    end
end

function PLUGIN:screenFade(target, color, time)
    if !target then return end
    if !istable(target) then target = {target} end

    for _,target in ipairs(target) do
        if !IsEntity(target) or !target:IsPlayer() then continue end
        if !target:getChar() then continue end

        target:ScreenFade(time and SCREENFADE.OUT or SCREENFADE.STAYOUT, color, 0.5, time or 0)
        target.ScreenFadeBlack = true

        if time then
            timer.Simple(time, function()
                target:ScreenFade(SCREENFADE.IN, color, 0.5, 1)
                target.ScreenFadeBlack = false
            end)
        end
    end
end

nut.command.add("screenfadeblack", {
    syntax = "<optional string player> [optional number time]",
    onCheckAccess = function(client)
        return client:EV_HasPrivilege("screenfadeblack")
    end,
    onRun = function(client, arguments)
        if arguments[1] then 
            local target = nut.command.findPlayer(client, arguments[1])
            if target then
                PLUGIN:screenFade(target, color_black, tonumber(arguments[2]))
            end
        elseif !arguments[1] or arguments[1] == "nil" then
            PLUGIN:screenFade(player.GetAll(), color_black, tonumber(arguments[2]))
        end

        return true
    end,
})

nut.command.add("screenfadewhite", {
    syntax = "<optional string player> [optional number time]",
    onCheckAccess = function(client)
        return client:EV_HasPrivilege("screenfadewhite")
    end,
    onRun = function(client, arguments)
        if arguments[1] then 
            local target = nut.command.findPlayer(client, arguments[1])
            if target then
                PLUGIN:screenFade(target, color_white, tonumber(arguments[2]))
            end
        elseif !arguments[1] or arguments[1] == "nil" then
            PLUGIN:screenFade(player.GetAll(), color_white, tonumber(arguments[2]))
        end

        return true
    end,
})

nut.command.add("screenfaderemove", {
    syntax = "<optional string player>",
    onCheckAccess = function(client)
        return client:EV_HasPrivilege("screenfaderemove")
    end,
    onRun = function(client, arguments)
        if arguments[1] then
            local target = nut.command.findPlayer(client, arguments[1])
            if target then
                target:ScreenFade(SCREENFADE.PURGE, color_black, 0, 0)
                target:ScreenFade(SCREENFADE.IN, target.ScreenFadeBlack and color_black or color_white, 0.5, 1)
                target[target.ScreenFadeBlack and "ScreenFadeBlack" or "ScreenFadeWhite"] = false
            end
        else
            for _,target in ipairs(player.GetAll()) do
                if !target:getChar() then continue end

                target:ScreenFade(SCREENFADE.PURGE, color_black, 0, 0)
                target:ScreenFade(SCREENFADE.IN, target.ScreenFadeBlack and color_black or color_white, 0.5, 1)
                target[target.ScreenFadeBlack and "ScreenFadeBlack" or "ScreenFadeWhite"] = false
            end
        end

        return true
    end,
})