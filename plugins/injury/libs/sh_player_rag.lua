local PLUGIN = PLUGIN

local playerMeta = FindMetaTable("Player")

if(SERVER) then
	function playerMeta:createRagdoll(freeze, velo)
		local entity = ents.Create("prop_ragdoll")
		entity:SetPos(self:GetPos())
		entity:SetAngles(self:EyeAngles())
		entity:SetModel(self:GetModel())
		entity:SetSkin(self:GetSkin())
		entity:Spawn()
		entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		entity:Activate()

		local velocity = (velo or Vector(0,0,0)) + self:GetVelocity()
		
		for i = 0, entity:GetPhysicsObjectCount() - 1 do
			local physObj = entity:GetPhysicsObjectNum(i)
			if (IsValid(physObj)) then
				local index = entity:TranslatePhysBoneToBone(i)
				if (index) then
					local position, angles = self:GetBonePosition(index)

					physObj:SetPos(position)
					physObj:SetAngles(angles)
				end
				if (freeze) then
					physObj:EnableMotion(false)
				else
					physObj:SetVelocity(velocity)
				end
			end
		end

		return entity
	end
	
	function playerMeta:setRagdolledI(state, time, getUpGrace, blur, velo)
		getUpGrace = getUpGrace or time or 5

		if (state) then
			if (IsValid(self.nutRagdoll)) then
				self.nutRagdoll:Remove()
			end

			if(!self:Alive()) then return false end --dont duplicate ragdolls of deal people please
			
			local entity = self:createRagdoll(false, velo)
			
			local function PhysCallback(ent, data) -- Function that will be called whenever collision happens
				if (data) then
					if data.Speed > 50 then
						util.Decal("Blood", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
					end
				end
			end
			entity:AddCallback("PhysicsCollide", PhysCallback) -- Add Callback
			
			entity:setNetVar("player", self)
			entity:CallOnRemove("fixer", function()
				if (IsValid(self)) then
					self:setLocalVar("blur", nil)
					self:setLocalVar("ragdoll", nil)

					if (!entity.nutNoReset) then
						self:SetPos(entity:GetPos())
					end

					self:SetNoDraw(false)
					self:SetNotSolid(false)
					self:Freeze(false)
					self:SetMoveType(MOVETYPE_WALK)
					self:SetLocalVelocity(
						IsValid(entity)
						and entity.nutLastVelocity
						or vector_origin
					)
				end

				if (IsValid(self) and !entity.nutIgnoreDelete) then
					if (entity.nutWeapons) then
						for k, v in ipairs(entity.nutWeapons) do
							local weapon = self:Give(v)

							if (entity.nutAmmo) then
								for k2, v2 in ipairs(entity.nutAmmo) do
									if v == v2[1] then
										self:SetAmmo(v2[2], tostring(k2))
									end
								end
							end
						end
						
						for k, v in ipairs(self:GetWeapons()) do
							v:SetClip1(0)
						end
					end

					if (self:isStuck()) then
						entity:DropToFloor()
						self:SetPos(entity:GetPos() + Vector(0, 0, 16))

						local positions = nut.util.findEmptySpace(
							self,
							{entity, self}
						)
						for k, v in ipairs(positions) do
							self:SetPos(v)

							if (!self:isStuck()) then
								return
							end
						end
					end
				end
			end)

			self:setLocalVar("blur", blur or 11)
			self.nutRagdoll = entity

			entity.nutWeapons = {}
			entity.nutAmmo = {}
			entity.nutPlayer = self

			if (getUpGrace) then
				entity.nutGrace = CurTime() + getUpGrace
			end

			if (time and time > 0) then
				entity.nutStart = CurTime()
				entity.nutFinish = entity.nutStart + time

				self:setAction(
					"Trying to get up...",
					nil, nil,
					entity.nutStart, entity.nutFinish
				)
			end

			for k, v in ipairs(self:GetWeapons()) do
				entity.nutWeapons[#entity.nutWeapons + 1] = v:GetClass()
				local clip = v:Clip1()
				local reserve = self:GetAmmoCount(v:GetPrimaryAmmoType())
				local ammo = clip + reserve
				
				self:SetAmmo(ammo, v:GetPrimaryAmmoType())
				
				entity.nutAmmo[v:GetPrimaryAmmoType()] = {v:GetClass(), ammo}
			end

			self:GodDisable()
			self:StripWeapons()
			self:Freeze(true)
			self:SetNoDraw(true)
			self:SetNotSolid(true)
			self:SetMoveType(MOVETYPE_NONE)

			if (time) then
				local time2 = time
				local uniqueID = "nutUnRagdoll"..self:SteamID()

				timer.Create(uniqueID, 0.33, 0, function()
					if (IsValid(entity) and IsValid(self)) then
						local velocity = entity:GetVelocity()
						entity.nutLastVelocity = velocity

						self:SetPos(entity:GetPos())

						if (velocity:Length2D() >= 8) then
							if (!entity.nutPausing) then
								self:setAction()
								entity.nutPausing = true
							end

							return
						elseif (entity.nutPausing) then
							self:setAction("Trying to get up...", time)
							entity.nutPausing = false
						end

						time = time - 0.33

						if (time <= 0) then
							entity:Remove()
						end
					else
						timer.Remove(uniqueID)
					end
				end)
			end

			self:setLocalVar("ragdoll", entity:EntIndex())
			--hook.Run("OnCharFallover", self, entity, true)
		elseif (IsValid(self.nutRagdoll)) then
			self.nutRagdoll:Remove()

			--hook.Run("OnCharFallover", self, entity, false)
		end
	end	
end
