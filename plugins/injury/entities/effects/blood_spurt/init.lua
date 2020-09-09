local m_Rand = math.Rand
local m_Random = math.random

function EFFECT:Init( data )
	self.StartPos = data:GetOrigin()
	
	self.Dir = data:GetNormal()
	
	self.LifeTime 	= 5
	
	self.DieTime 	= CurTime() + self.LifeTime
	
	self.Grav 	= Vector(0, 0, 10)
	
	self.emitter = ParticleEmitter(self.StartPos)
	
	self.targent = data:GetEntity()
	
	local bt = data:GetColor()
	
	self.rawbt = bt and bt or 0
	
	local col = Color(192,0,0,255)
	
	self.partcol = col
	
	self.lastblood = -1
end

local redcol = Color(255,0,0,255)

local collidefunc = function(part,hitPos,hitNormal)
			local r,g,b = part:GetColor()
			if (math.max(r,g,b)>80) and (m_Rand(0, 5)<=1 )then
				util.Decal("Blood",hitPos-hitNormal,hitPos+hitNormal)
				
				--[[
				if m_Rand(0,1)<=1 then
					sound.Play("BGO.BloodDrop",hitPos)
				end
				--]]

				local fx = EffectData()
				fx:SetOrigin(hitPos)
				fx:SetNormal(hitNormal)
				--fx:SetColor(self.rawbt and self.rawbt or 0)
				util.Effect("BloodImpact",fx)

			--[[
			elseif m_Rand(0,6)<=1 then
				sound.Play("BGO.BloodDrop",hitPos)
			--]]
			end
			
			if IsValid(part) then
				part:Remove()
			end
		end

local ct		
local basevel = 160

function EFFECT:Think( )
	ct = CurTime()
	
	if ct>self.DieTime then
		if IsValid(self.emitter) then
			self.emitter:Finish()
		end
		return false
	end
	
	if self.targent and !IsValid(self.targent) then
		if IsValid(self.emitter) then
			self.emitter:Finish()
		end
		return false
	end
	
	if self.partcol and m_Rand(0, 1) <= 1 and (CurTime()-self.lastblood)>(1/30) then
	
		self.lastblood = CurTime()
	
		local col = self.partcol
		local i = 1
		local count = 15
		
		--self.emitter:Finish()
	
		--self.emitter = ParticleEmitter(self.targent:GetPos())
	
		self.emitter:SetPos(self.targent:GetPos())
		
		while i<count do
			self.Dir = self.targent:GetAngles():Up()
			local part = self.emitter:Add("effects/blood_drop", self.StartPos)
			
			local mycol = Color(m_Rand(col.r*3/4,col.r),m_Rand(col.g*3/4,col.g),m_Rand(col.b*3/4,col.b),255)
			
			local asr = 1
			local asf = 1
			
			part:SetPos(self.targent:GetPos() + Vector(0,0,40) + VectorRand() * 5)
			part:SetVelocity( (self.Dir + VectorRand() * 1*0.01) * m_Rand( basevel-basevel*1*0.01, basevel ) * 1 * ( 1-asf/2 + math.sin( ( ct%(1/asr) ) * 7.28 / asr ) * asf/2 ) )
			part:SetDieTime(m_Rand(1, 3))
			part:SetStartAlpha(m_Random(225,255))
			part:SetEndAlpha(0)
			part:SetStartSize(m_Rand(2, 4) )
			part:SetEndSize(0.05)
			part:SetRoll(0)
			part:SetGravity(Vector(0,0,-500))
			part:SetCollide(true)
			part:SetBounce(0)
			part:SetAirResistance(0.25)
			part:SetStartLength(0.075)
			part:SetEndLength(0.15)
			part:SetVelocityScale(true)
			part:SetColor(mycol.r*0.5,mycol.g*0.5,mycol.b*0.5)
			
			part:SetCollideCallback( collidefunc )
			
			i=i+1
			
		end
		
		self.emitter:Finish()
		
		return false
		
	end
end

function EFFECT:Render()
	return false
end