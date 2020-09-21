local PLUGIN = PLUGIN
PLUGIN.name = "Evolve helpers"
PLUGIN.desc = "Functions to help Evolve integrate with NS"
PLUGIN.author = "rusty"

nut.evolve = PLUGIN

function PLUGIN:PluginInitialized()
    if !evolve then
        ErrorNoHalt("[NutScript Evolve] You have the Evolve support plugin installed but Evolve isn't installed.")
    end
end

function PLUGIN:AddPrivilege(command)
    table.Add( evolve.privileges, {command} )
    table.sort( evolve.privileges )
end