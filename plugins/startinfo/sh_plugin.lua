local PLUGIN = PLUGIN
PLUGIN.name = "Character Info"
PLUGIN.author = "Chancer"
PLUGIN.desc = "Information that shows up in character creation."

--adds the traitstep gui to the char creation menu
if(CLIENT) then
	function PLUGIN:ConfigureCharacterCreationSteps(panel)
		panel:addStep(vgui.Create("nutStartInfo"), 1) --the number determines the order
	end
end