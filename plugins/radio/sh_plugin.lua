PLUGIN.name = "Radio"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "You can communicate with other people in distance."
local RADIO_CHATCOLOR = Color(100, 255, 50)

-- This is how initialize Language in Single File.
local langkey = "english"
local langTable = {
	radioFreq = "Frequency",
	radioSubmit = "Submit",
	radioNoRadio = "You don't have any radio to adjust.",
	radioNoRadioComm = "You don't have any radio to communicate",
	radioFormat = "%s radios in \"%s\"",
}

function PLUGIN:PluginLoaded()
	table.Merge(nut.lang.stored[langkey], langTable)
end

if (CLIENT) then
	local PANEL = {}
	function PANEL:Init()
		self.number = 0
		self:SetWide(70)

		local up = self:Add("DButton")
		up:SetFont("Marlett")
		up:SetText("t")
		up:Dock(TOP)
		up:DockMargin(2, 2, 2, 2)
		up.DoClick = function(this)
			self.number = (self.number + 1)% 10
			surface.PlaySound("buttons/lightswitch2.wav")
		end

		local down = self:Add("DButton")
		down:SetFont("Marlett")
		down:SetText("u")
		down:Dock(BOTTOM)
		down:DockMargin(2, 2, 2, 2)
		down.DoClick = function(this)
			self.number = (self.number - 1)% 10
			surface.PlaySound("buttons/lightswitch2.wav")
		end

		local number = self:Add("Panel")
		number:Dock(FILL)
		number.Paint = function(this, w, h)
			draw.SimpleText(self.number, "nutDialFont", w/2, h/2, color_white, 1, 1)
		end
	end

	vgui.Register("nutRadioDial", PANEL, "DPanel")

	PANEL = {}

	function PANEL:Init()
		self:SetTitle(L("radioFreq"))
		self:SetSize(330, 390)
		self:Center()
		self:MakePopup()

		self.topPanel = self:Add("DPanel")
		self.topPanel:SetSize(330, 160)
		self.topPanel:Dock(TOP)
		self.topPanel.Paint = function() end

		self.bottomPanel = self:Add("DPanel")
		self.bottomPanel:SetSize(330, 160)
		self.bottomPanel:DockMargin(0, 5, 0, 0)
		self.bottomPanel:Dock(TOP)
		self.bottomPanel.Paint = function() end
		self.bottomPanel.PaintOver = function(self, w, h)
			draw.SimpleText("CH", "nutDialFont", 88, h/2, color_white, 1, 1)
		end

		self.submit = self:Add("DButton")
		self.submit:Dock(TOP)
		self.submit:DockMargin(0, 5, 0, 0)
		self.submit:SetTall(25)
		self.submit:SetText(L("radioSubmit"))
		self.submit.DoClick = function()
			local str = ""
			for i = 1, 5 do
				if (i != 4) then
					str = str .. tostring(self.dial[i].number or 0)
				else
					str = str .. "."
				end
			end

			local chan = ""
			for i = 1, 2 do
				chan = chan .. tostring(self.channelDial[i].number or 0)
			end

			netstream.Start("radioAdjust", str, self.itemID, tonumber(chan))

			self:Close()
		end

		self.dial = {}
		for i = 1, 5 do
			if (i != 4) then
				self.dial[i] = self.topPanel:Add("nutRadioDial")
				self.dial[i]:Dock(LEFT)
				if (i != 3) then
					self.dial[i]:DockMargin(0, 0, 5, 0)
				end
			else
				local dot = self.topPanel:Add("Panel")
				dot:Dock(LEFT)
				dot:SetWide(30)
				dot.Paint = function(this, w, h)
					draw.SimpleText(".", "nutDialFont", w/2, h - 10, color_white, 1, 4)
				end
			end
		end

		self.channelDial = {}
		for i=2, 1, -1 do
			local dial = self.bottomPanel:Add("nutRadioDial")
			dial:DockMargin(5, 0, 0, 0)
			dial:Dock(RIGHT)
			self.channelDial[i] = dial
		end
	end

	function PANEL:Think()
		self:MoveToFront()
	end

	vgui.Register("nutRadioMenu", PANEL, "DFrame")

	surface.CreateFont("nutDialFont", {
		font = "Agency FB",
		size = 100,
		weight = 1000
	})

	surface.CreateFont("nutRadioFont", {
		font = "Lucida Sans Typewriter",
		size = math.max(ScreenScale(7), 17),
		weight = 100
	})

	netstream.Hook("radioAdjust", function(freq, id, channel)
		local adjust = vgui.Create("nutRadioMenu")

		if (id) then
			adjust.itemID = id
		end

		if (freq) then
			for i = 1, 5 do
				if (i != 4) then
					adjust.dial[i].number = tonumber(freq[i])
				end
			end

			local chString = tostring(math.floor(tonumber(channel)))
			if (#chString == 1) then
				adjust.channelDial[2].number = tonumber(chString[1])
			else
				adjust.channelDial[1].number = tonumber(chString[1])
				adjust.channelDial[2].number = tonumber(chString[2])
			end
		end
	end)
else
	netstream.Hook("radioAdjust", function(client, freq, id, channel)
		local inv = (client:getChar() and client:getChar():getInv() or nil)

		if (inv) then
			local item

			if (id) then
				item = nut.item.instances[id]
			else
				item = inv:hasItem("radio")
			end

			local ent = item:getEntity()

			if (item and (IsValid(ent) or item:getOwner() == client)) then
				(ent or client):EmitSound("buttons/combine_button1.wav", 50, 170)
				item:setData("freq", freq)
				item:setData("channel", tonumber(channel) or 1)
			else
				client:notifyLocalized("radioNoRadio")
			end
		end
	end)

	/* Do we need it?
	nut.command.add("freq", {
		syntax = "<string name> [string flags]",
		onRun = function(client, arguments)
			local inv = client:getChar():getInv()

			if (inv) then
				local detect = {
					"radio",
					"sradio",
					"pager"
				}

				for k, v in ipairs(detect) do
					item = inv:hasItem(v)
				end

				if (item) then


					item:setData("freq", arguments[1], nil, nil, true)
				else
					client:notify("You do not have any radio to adjust.")
				end
			end
		end
	})
*/
end

-- Yelling out loud.
local find = {
	["radio"] = false,
	["sradio"] = true
}
local function endChatter(listener)
	timer.Simple(1, function()
		if (!listener:IsValid() or !listener:Alive() or hook.Run("ShouldRadioBeep", listener) == false) then
			return false
		end

		listener:EmitSound("npc/metropolice/vo/off"..math.random(1, 3)..".wav", math.random(60, 70), math.random(80, 120))
	end)
end

nut.chat.register("radio", {
	format = "%s says in radio: \"%s\"",
	font = "nutRadioFont",
	onGetColor = function(speaker, text)
		return RADIO_CHATCOLOR
	end,
	onCanHear = function(speaker, listener)
		local dist = speaker:GetPos():Distance(listener:GetPos())
		local speakRange = nut.config.get("chatRange", 280)
		local listenerEnts = ents.FindInSphere(listener:GetPos(), speakRange)
		local listenerInv = listener:getChar():getInv()
		local freq

		if (!CURFREQ or CURFREQ == "" || !CURCHANNEL) then
			return false
		end

		if (dist <= speakRange) then
			return true
		end

		if (listenerInv) then
			for k, v in pairs(listenerInv:getItems()) do
				if (freq) then
					break
				end

				for id, far in pairs(find) do
					if (v.uniqueID == id and v:getData("power", false) == true) then
						if (CURFREQ == v:getData("freq", "000.0") and CURCHANNEL == v:getData("channel", 1)) then
							endChatter(listener)
							
							return true
						end

						break
					end
				end
			end
		end

		if (!freq) then
			for k, v in ipairs(listenerEnts) do
				if (freq) then
					break
				end

				if (v:GetClass() == "nut_item") then
					local itemTable = v:getItemTable()

					for id, far in pairs(find) do
						if (far and itemTable.uniqueID == id and v:getData("power", false) == true) then
							if (CURFREQ == v:getData("freq", "000.0") and CURCHANNEL == v:getData("channel", 1)) then
								endChatter(listener)

								return true
							end
						end
					end
				end
			end
		end

		return false
	end,
	onCanSay = function(speaker, text)
		local schar = speaker:getChar()
		local speakRange = nut.config.get("chatRange", 280)
		local speakEnts = ents.FindInSphere(speaker:GetPos(), speakRange)
		local speakerInv = schar:getInv()
		local freq
		local channel

		if (speakerInv) then
			for k, v in pairs(speakerInv:getItems()) do
				if (freq) then
					break
				end

				for id, far in pairs(find) do
					if (v.uniqueID == id and v:getData("power", false) == true) then
						freq = v:getData("freq", "000.0")
						channel = v:getData("channel", 1)
						break
					end
				end
			end
		end

		if (!freq) then
			for k, v in ipairs(speakEnts) do
				if (freq) then
					break
				end

				if (v:GetClass() == "nut_item") then
					local itemTable = v:getItemTable()

					for id, far in pairs(find) do
						if (far and itemTable.uniqueID == id and v:getData("power", false) == true) then
							freq = v:getData("freq", "000.0")
							channel = v:getData("channel", 1)
							break
						end
					end
				end
			end
		end

		if (freq) then
			CURFREQ = freq
			if (channel) then
				CURCHANNEL = channel
			end
			speaker:EmitSound("npc/metropolice/vo/on"..math.random(1, 2)..".wav", math.random(50, 60), math.random(80, 120))
		else
			speaker:notifyLocalized("radioNoRadioComm")
			return false
		end
	end,
	prefix = {"/r", "/radio"},
})
