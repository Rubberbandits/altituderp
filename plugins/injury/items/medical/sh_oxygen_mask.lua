ITEM.name = "Oxygen Mask"

ITEM.desc = "A tool used to transfer breathable oxygen from a storage tank into the lungs of a patient."

ITEM.model = "models/illusion/eftcontainers/ifak.mdl"

ITEM.width = 1

ITEM.height = 1

ITEM.flag = "v"

ITEM.category = "Medical"

ITEM.color = Color(232, 0, 0)

ITEM.quantity2 = 5



ITEM.useTime = 6

--ITEM.useText = "slides an oxygen mask over the face of"



ITEM.targetOnly = true



ITEM.charges = true

ITEM.chargeReq = "oxygen_tank"



ITEM.useSound = "oxygenmasksounds.mp3"



ITEM.restore = {

	["oxygen"] = 2000,

}



ITEM.pacData = {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

				},

				["self"] = {

					["Skin"] = 0,

					["Invert"] = false,

					["LightBlend"] = 1,

					["CellShade"] = 0,

					["OwnerName"] = "self",

					["AimPartName"] = "",

					["IgnoreZ"] = false,

					["AimPartUID"] = "",

					["Passes"] = 1,

					["Name"] = "",

					["NoTextureFiltering"] = false,

					["DoubleFace"] = false,

					["PositionOffset"] = Vector(0, 0, 0),

					["IsDisturbing"] = false,

					["Fullbright"] = false,

					["EyeAngles"] = false,

					["DrawOrder"] = 0,

					["TintColor"] = Vector(0, 0, 0),

					["UniqueID"] = "3881603151",

					["Translucent"] = false,

					["LodOverride"] = -1,

					["BlurSpacing"] = 0,

					["Alpha"] = 1,

					["Material"] = "",

					["UseWeaponColor"] = false,

					["UsePlayerColor"] = false,

					["UseLegacyScale"] = false,

					["Bone"] = "head",

					["Color"] = Vector(255, 255, 255),

					["Brightness"] = 1,

					["BoneMerge"] = false,

					["BlurLength"] = 0,

					["Position"] = Vector(2.6151123046875, -7.336181640625, 0.0308837890625),

					["AngleOffset"] = Angle(0, 0, 0),

					["AlternativeScaling"] = false,

					["Hide"] = false,

					["OwnerEntity"] = false,

					["Scale"] = Vector(1, 1, 1),

					["ClassName"] = "model",

					["EditorExpand"] = false,

					["Size"] = 1,

					["ModelFallback"] = "",

					["Angles"] = Angle(-0.46775445342064, -69.64347076416, -91.443954467773),

					["TextureFilter"] = 3,

					["Model"] = "models/codeandmodeling/ag_masque_oxygene.mdl",

					["BlendMode"] = "",

				},

			},

		},

		["self"] = {

			["DrawOrder"] = 0,

			["UniqueID"] = "3922551209",

			["AimPartUID"] = "",

			["Hide"] = false,

			["Duplicate"] = false,

			["ClassName"] = "group",

			["OwnerName"] = "self",

			["IsDisturbing"] = false,

			["Name"] = "my outfit",

			["EditorExpand"] = true,

		},

	},

}



function ITEM:removePart(client)

	if (client.removePart) then

		client:removePart(self.uniqueID)

	end

end



ITEM.functions.usef = { -- sorry, for name order.

	name = "Use Forward",

	tip = "useTip",

	icon = "icon16/arrow_up.png",

	onRun = function(item)

		local client = item.player

		local position = client:getItemDropPos()

		local trace = client:GetEyeTraceNoCursor() -- We don't need cursors.

		local target = trace.Entity



		if (IsValid(target) and (target:IsPlayer() or target:getNetVar("player"))) then

			target = target:getNetVar("player", target) --makes it so we can do this to ragdolled people too

		

			if(item.useText) then

				nut.chat.send(client, "me", item.useText.. " " ..target:Name().. ".")

			end

			

			if(item.useSound) then

				client:EmitSound(item.useSound)

			end

			

			client:Freeze(true)

			client:setAction("Applying " ..item.name.. "..." , item.useTime or 0, function()

				client:Freeze(false)		



				if(item.injFix) then

					local repair = table.Copy(item.injFix) --the amount of "fixing" it will do

				

					local injuries = target:getChar():getData("injury", {})

					

					for part, injuryTbl in pairs(injuries) do

						for injuryType, injury in pairs(injuryTbl) do

							if(repair[injuryType]) then

								target:removeInjury(part, injuryType, repair[injuryType]) --removes the injury or a part of the injury

								repair[injuryType] = math.max(repair[injuryType] - injury, 0) --reduce the remaining "fixing" value on the item so it can be applied on other injuries

							end

						end

					end

					

					target:getChar():setData("injury", injuries)

					

					target:updateLoss()

					target:speedUpdate()

					

					client:getChar():setData("injuryPost", true)

				end

				

				if(item.restore) then

					for k, v in pairs(item.restore) do

						target:addHealthStatus(k, v)

					end

				end

				

				if(item.useText) then

					nut.chat.send(client, "me", "finishes applying " ..item.name.. ".")

				end

				

				if (target.addPart) then

					target:addPart(item.uniqueID)

					target:setNetVar("mask", true)

					

					timer.Simple(600, function()

						if(IsValid(target)) then

							target:removePart(item.uniqueID)

							target:setNetVar("mask", nil)

						end

					end)

				end

				

				local quantity2 = item:getData("quantity2", item.quantity2 or 1)

				if(tonumber(quantity2) > 1) then

					item:setData("quantity2", quantity2 - 1)

					return false

				else

					if(item.container) then

						nut.item.spawn(item.container, position)

					end

					

					if(item.charges) then

						return false

					else

						item:remove()

					end

				end

			end)

		end



		return false

	end,

	onCanRun = function(item)

		local quantity2 = item:getData("quantity2", item.quantity2 or 1)

		if(quantity2 <= 0) then

			return false

		end

	

		if(IsValid(item.entity)) then

			return false

		end

	

		return true

	end

}