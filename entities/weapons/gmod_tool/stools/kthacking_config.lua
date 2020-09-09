TOOL.Category = "Hacking System"
TOOL.Name = "Hackable Entity Configurator"
TOOL.Command = nil
TOOL.ConfigName = ""
TOOL.ClientConVar[ "hack_time" ] = 30
TOOL.ClientConVar[ "hack_triggers" ] = ""
TOOL.ClientConVar[ "cooldown_hacker" ] = 30
TOOL.ClientConVar[ "cooldown_entity" ] = 30
function TOOL:LeftClick( trace )
end
 
function TOOL:RightClick( trace )
end

function TOOL:Reload( trace )
end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel(panel)
  panel:AddControl("Header", { Text = "Hackable Entity Configurator", Description = "Allows configuring entities to be hackable with KT's Hacking system" })
 
  panel:AddControl("Slider", {
    Label = "Time required to Hack",
    Min = "0",
    Max = "600",
    Command = "hack_time"
  })
  
   panel:AddControl("Slider", {
    Label = "Re-hacking cooldown for the Entity",
    Min = "0",
    Max = "600",
    Command = "cooldown_entity"
  })
  
    panel:AddControl("Slider", {
    Label = "Re-hacking cooldown for the Hacker",
    Min = "0",
    Max = "600",
    Command = "cooldown_hacker"
  })
 
  panel:AddControl("Textbox", {
    Label = "Fire Triggers on Hack, separated by newlines (example: Open, Close, Lock, Unlock,...)",
	Command = "hack_triggers",
  })
end

