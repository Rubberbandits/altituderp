AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Dungeon Door"
ENT.Category = "NutScript"
ENT.Spawnable = false

if (SERVER) then
	function ENT:Initialize(doorModel)
		self:SetModel(tostring(doorModel) or "models/props_c17/door01_left.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(false)

		self:setNetVar("doorID", 0)
		self:setNetVar("linkedDoor", 0)
		self:setNetVar("doorData", {})
		self:setNetVar("locked", false)
		self:setNetVar("password", false)
		self:setNetVar("hidden", true)

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Wake()
		end;
	end;

	function ENT:Fade(player)
		self:EmitSound("doors/door1_move.wav", 65)
		self:getNetVar("linkedDoor"):EmitSound("doors/door1_move.wav", 65)

		player:Freeze(true)
		player:setNetVar("sFadeIn", true)

		timer.Simple(1, function()
			local vector = self:getNetVar("linkedDoor"):GetPos() + self:getNetVar("linkedDoor"):GetUp() * 20
			player:SetPos(vector + self:getNetVar("linkedDoor"):GetForward() * -50)
		end)

		timer.Simple(2, function()
			player:Freeze(false)
			player:setNetVar("sFadeIn", false)
			player:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			timer.Simple(5, function() player:SetCollisionGroup(COLLISION_GROUP_PLAYER) end)
			self:EmitSound("doors/door_wood_close1.wav", 65)
			self:getNetVar("linkedDoor"):EmitSound("doors/door_wood_close1.wav", 65)
		end)
	end

	function ENT:Use(player)
		self.nextUse = self.nextUse or CurTime()
		if (self.nextUse > CurTime()) then
			return
		else
			self.nextUse = CurTime() + 1
		end

		if (self:getNetVar("linkedDoor") == 0) then
			player:ChatPrint("This door does not lead anywhere.")
			return
		end

		if (!self:getNetVar("password", false)) then
			self:Fade(player)
		else
			netstream.Start(player, "doorTelePass", self)
			self:getNetVar("linkedDoor"):EmitSound("doors/door_locked2.wav")
			self:EmitSound("doors/door_locked2.wav")
		end

	end
else
	local Alpha = 0

	hook.Add("HUDPaint", "FadeIn", function()
		if (LocalPlayer():getNetVar("sFadeIn")) then
			Alpha = math.min(Alpha + 15, 255)
		else
			Alpha = math.max(Alpha - 5, 0)
		end

		if (Alpha == 0) then return end

		surface.SetDrawColor(0, 0, 0, Alpha)
		surface.DrawRect(0, 0, ScrW(), ScrH())
	end)
end;
 