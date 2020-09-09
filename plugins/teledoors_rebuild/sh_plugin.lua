local PLUGIN = PLUGIN
PLUGIN.name = "Teleport Doors Rebuild"
PLUGIN.author = "BlackDenim"
PLUGIN.desc = "A working re-build of Vex's TeleDoors plugin, ported from Helix."

if (SERVER) then
	function PLUGIN:SaveData()
		local data = {}

		for _, v in pairs(ents.GetAll()) do
			if (v:GetClass() == "nut_teledoor") then
				if (v:getNetVar("linkedDoor", 0) != 0) then
					table.insert(data, {
						v:GetPos(),
						v:GetAngles(), 
						v:getNetVar("doorData", {}), 
						v:getNetVar("locked", false), 
						v:getNetVar("linkedDoor", 0):GetPos(),
						v:GetClass(), 
						v:getNetVar("password", false), 
						v:GetModel(),
						v:GetMaterial(),
						v:GetColor()
					})
				end
			end
		end

		self:setData(data)
	end

	function PLUGIN:LoadData()
		local data = self:getData({})
		if (!data) then return end;

		local doors = {}

		for _, v in pairs(data) do
			local ent = ents.Create(v[6])
			ent:SetPos(v[1])
			ent:SetAngles(v[2])
			ent:SetModel(v[8])
			ent:SetMaterial(v[9] or "")
			ent:SetColor(v[10] or Color(255,255,255))
			ent:SetRenderMode(RENDERMODE_TRANSALPHA)
			
			ent:Spawn()
			ent:setNetVar("doorData", v[3])
			ent:setNetVar("locked", v[4])
			ent:setNetVar("password", v[7])

			local physObj = ent:GetPhysicsObject()

			if (IsValid(physObj)) then
				physObj:EnableMotion(false)
				physObj:Wake()
			end

			doors[ent] = v[5]
		end

		for entity, linkedPos in pairs(doors) do
			for _, v in pairs(ents.GetAll()) do
				if (v:GetPos() == linkedPos and v:GetClass() == "nut_teledoor") then
					v:setNetVar("linkedDoor", entity)
					v:setNetVar("password", entity:getNetVar("password", false))
					
					break
				end
			end
		end
	end

	netstream.Hook("doorToggleState", function(entity)
		if (entity:getNetVar("status") != true) then
			entity.dummy:Fire("SetAnimation", "open", 0)
			entity:setNetVar("status", true)
			timer.Simple(3.5, function() entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS) end)
		else
			entity.dummy:Fire("SetAnimation", "close", 0)
			entity:setNetVar("status", false)
			timer.Simple(1.5, function() entity:SetCollisionGroup(COLLISION_GROUP_NONE) end)
		end
	end)

	netstream.Hook("doorTeleOpen", function(player, entity)
		entity:Fade(player)
	end)

	netstream.Hook("doorTeleWrongPW", function(player, entity)
		entity:EmitSound("doors/door_locked2.wav")
		player:notify("Wrong password!")
	end)
else
	netstream.Hook("doorTelePass", function(entity)
		Derma_StringRequest(
			"PASSWORD REQUIRED",
			"PASSWORD REQUIRED",
			"",
			function(password)
				if (entity:getNetVar("password", "0000") == password) then
					netstream.Start("doorTeleOpen", entity)
					else
					netstream.Start("doorTeleWrongPW", entity)
				end
			end
		)
	end)
end

nut.command.add("telecreate", {
	syntax = "<string model>",
	adminOnly = true,
	onRun = function(client, arguments, doorModel)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal*5
		local doorModel = arguments[1]
		
		if (!doorModel) then
			client:notify("Invalid model.")
		else
			local entity = ents.Create("nut_teledoor")
			entity:SetModel(doorModel)
			entity:SetPos(hitpos)
			entity:SetSolid(SOLID_VPHYSICS)
			entity:PhysicsInit(SOLID_VPHYSICS)
			entity:Spawn()
		end
	end
})

nut.command.add("telemodel", {
	syntax = "<string model>",
	adminOnly = true,
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local entity = trace.Entity
		
		if (IsValid(entity) and entity:GetClass("nut_teledoor")) then
			if (!arguments[1]) then
				client:notify("Invalid argument.")
			else
				entity:SetModel(arguments[1])
				entity:SetSolid(SOLID_VPHYSICS)
				entity:PhysicsInit(SOLID_VPHYSICS)
			end
		end
	end
})

nut.command.add("telepass", {
	syntax = "<string password>",
	adminOnly = true,
	onRun = function(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
			
		local target = util.TraceLine(data).Entity
		local password = arguments[1]
		
		if (target and target:GetClass():match("nut_teledoor")) then
			if (password) then
				target:setNetVar("password", password)
				target:getNetVar("linkedDoor"):setNetVar("password", password)
				
				client:notify("Password set.")
			else
				target:setNetVar("password", false)
				target:getNetVar("linkedDoor"):setNetVar("password", false)

				client:notify("Password removed.")
			end
		end
	end
})

nut.command.add("cleanteledoors", {
	syntax = "<number radius>",
	adminOnly = true,
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("Invalid argument.")
		else
			for k, v in pairs(ents.FindInSphere(client:GetPos(), arguments[1] or 64)) do	
				if IsValid(v) and (v:GetClass() == "nut_teledoor") then
					v:Remove()
					
					if (v:getNetVar("linkedDoor") != 0) then
						v:getNetVar("linkedDoor"):Remove()
					end
				end
			end
		end	
	end
})

