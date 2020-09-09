local PLUGIN = PLUGIN

AddCSLuaFile()

if(CLIENT) then
	SWEP.PrintName = "Teleporter Door Tool";
	SWEP.Slot = 0;
	SWEP.SlotPos = 0;
	--SWEP.CLMode = 0
end;

SWEP.HoldType = "pistol"

SWEP.Category = "Nutscript"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.AlwaysRaised = true

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.Delay			= 1
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= 0
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic   	= false
SWEP.Primary.Ammo         	= "none"

SWEP.Secondary.Delay		= 1
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 0
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"

function SWEP:Initialize()
end;

function SWEP:Deploy()
	return true
end;

function SWEP:Think()
end;

local lastUse = 0

if SERVER then
	local data = {}
	function SWEP:PrimaryAttack()
		if (lastUse > os.time()) then return false end;
		lastUse = os.time() + 1

		if (IsFirstTimePredicted()) then
			local entity = self.Owner:GetEyeTrace().Entity

			if (entity:GetClass():match("teledoor")) then
				data[1] = entity
				self.Owner:ChatPrint("Door one set!")
			else
				self.Owner:ChatPrint("Invalid door!")
			end;
		end;

		return true
	end;

	function SWEP:SecondaryAttack()
		if (lastUse > os.time()) then return false end;
		lastUse = os.time() + 1

		if (IsFirstTimePredicted()) then
			local entity = self.Owner:GetEyeTrace().Entity

			if (entity:GetClass():match("teledoor")) then
				data[2] = entity
				self.Owner:ChatPrint("Door two set!")
			else
				self.Owner:ChatPrint("Invalid door!")
			end;
		end;

		return true
	end;

	function SWEP:Reload()
		if (lastUse > os.time()) then return false end;
		lastUse = os.time() + 1

		if (IsFirstTimePredicted()) then
			if (IsValid(data[1]) and IsValid(data[2])) then
				data[1]:setNetVar("linkedDoor", data[2])
				data[2]:setNetVar("linkedDoor", data[1])
				self.Owner:ChatPrint("Doors linked!")
				data = {}
			else
				self.Owner:ChatPrint("Door missing!")
			end;
		end;
	end;
end

if CLIENT then
	function SWEP:DrawHUD()
		local w, h = ScrW(), ScrH()
		local cury = h/4*3
		local tx, ty = draw.SimpleText("Left Click: Set Door One", "nutMediumFont", w/2, cury, color_white, 1, 1)
		cury = cury + ty
		local tx, ty = draw.SimpleText("Right Click: Set Door Two", "nutMediumFont", w/2, cury, color_white, 1, 1)
		cury = cury + ty
		local tx, ty = draw.SimpleText("Reload: Link Doors", "nutMediumFont", w/2, cury, color_white, 1, 1)

		local trace = LocalPlayer():GetEyeTraceNoCursor()
		local pos = trace.HitPos

		surface.SetDrawColor(255, 0, 0)
		local aimPos = pos:ToScreen()
		if (pos and aimPos) then
			surface.DrawLine(aimPos.x, aimPos.y - 10, aimPos.x, aimPos.y + 10)
			surface.DrawLine(aimPos.x - 10, aimPos.y, aimPos.x + 10, aimPos.y)
		end;
	end;
end;
