
local PLUGIN = PLUGIN
local PANEL = {}

function PANEL:Init()
	self.title = self:addLabel("Setting")
	
	--[[
	self.list = self:Add("DScrollPanel")
	self.list:Dock(FILL)
	
	self.list:SetDrawBackground(false)
	--]]
	
	self.desc = self:Add("DTextEntry")--self:addLabel("")
	self.desc:DockMargin(0, 8, 0, 0)
	self.desc:SetSize(ScrW() * 0.35, ScrH() * 0.7)
	self.desc:SetPos(0, 50)
	self.desc:SetFont("nutCharSubTitleFont")
	self.desc:SetTextColor(Color(255,255,255))
	self.desc:SetPaintBackground(false)
	self.desc:SetWrap(true)
	self.desc:SetMultiline(true)
	--self.desc:SetAutoStretchVertical(true)
end

function PANEL:onDisplay()
	local setting = [[
	You are a soldier in the Western European Coalition, the organization that formed as a branch off of the United Nations after Russia, China, Iran and their major allies broke away. This cataclysmic event shattered the U.N., leaving the remaining member countries to pick up the pieces. Many found themselves subject to a draft on their respective sides, even more simply volunteered, feeling it their duty to fight for their country. Where you have been deployed, the Eurasian Front and the Western European Coalition are always pitted at odds in:
	
	Kiev, Ukraine (Outskirts). 
	
	Kiev was subject to horrific amounts of both biological and chemical warfare, resulting in deformities and changes that none could even begin to fathom... Many people are left homeless, relying solely on the carepackages and rations provided by the W.E.C. and their allies. Violent crime is commonplace in Kiev, as the city sits in squalor and ruins. Despite the Russians being the number one reason that the local populace live so poorly, some still believe that Russia is their one true ruler.

	With tensions reaching an all time high, the fate of this war teeters on success of the respective sides on the frontlines. In this reality, it's kill or be killed. Most know that in the end, there are few ways that this war will end happily... This is nothing like the previous world wars, this is something new entirely... This is SHATTERED.

	]]

	self.desc:SetText(setting)
	self.desc.AllowInput = function()
		return true
	end
	self.desc:SetEnabled(false)
end

vgui.Register("nutStartInfo", PANEL, "nutCharacterCreateStep")