local PLUGIN = PLUGIN

local WOUND_BROKEN = 1
local WOUND_BULLET = 2

PLUGIN.thresh = {
	blood = {
		[1000] = {
			self = "You are bleeding.",
			obs = "blood levels are normal.",
		},
		[800] = {
			self = "You feel cold, you have lost some blood.",
			obs = "has lost some blood.",
		},
		[600] = {
			self = "You feel very cold, you have lost a lot of blood.",
			obs = "has lost a lot of blood.",
		},
		[400] = {
			self = "You feel very cold, you have lost a lot of blood.",
			obs = "has lost too much blood, and will die without proper treatment.",
		},
		[200] = {
			self = "You feel your life fading away.",
			obs = "has lost too much blood, and will die very soon unless something is done.",
		},
		[0] = {
			self = "",
			obs = "has died from blood loss.",
		},
	},
	oxygen = {
		[1000] = {
			self = "You are having slight breathing problems.",
			obs = "oxygen levels are normal.",
		},
		[800] = {
			self = "You are having trouble breathing.",
			obs = "oxygen levels are somewhat low.",
		},
		[600] = {
			self = "You can barely breathe.",
			obs = "oxygen levels are low.",
		},
		[400] = {
			self = "You can't breathe.",
			obs = "is properly breathing, their oxygen levels are very low.",
		},
		[200] = {
			self = "You can't breathe, the end is near.",
			obs = "isn't breathing, and will die soon.",
		},
		[0] = {
			self = "",
			obs = "has died from a lack of oxygen.",
		},
	},
	heart = {
		[1000] = {
			self = "Your heart is racing.",
			obs = "heart rate is normal.",
		},
		[800] = {
			self = "Your heart is beating quickly.",
			obs = "heart rate is slightly higher than normal.",
		},
		[600] = {
			self = "Your heart is beating very quickly, and your chest hurts.",
			obs = "heart rate is high.",
		},
		[400] = {
			self = "Your heart feels like it's going to explode.",
			obs = "heart rate is incredibly fast.",
		},
		[200] = {
			self = "You have an overwhelming feeling of dread.",
			obs = "has entered cardiac arrest.",
		},
		[0] = {
			self = "",
			obs = "has died from cardiac arrest.",
		},
	},
}

PLUGIN.injuries = {
	[WOUND_BROKEN] = {
		name = "Broken",
		groups = {
			--no broken arms for right now
			--[HITGROUP_LEFTARM] = "Left Arm",
			--[HITGROUP_RIGHTARM] = "Right Arm",
			[HITGROUP_LEFTLEG] = "Left Leg",
			[HITGROUP_RIGHTLEG] = "Right Leg",
		},
	},
	
	[WOUND_BULLET] = {
		name = "Bullet Wound",
		groups = {
			[HITGROUP_HEAD] = "Head",
			[HITGROUP_CHEST] = "Chest",
			[HITGROUP_STOMACH] = "Stomach",
			[HITGROUP_LEFTARM] = "Left Arm",
			[HITGROUP_RIGHTARM] = "Right Arm",
			[HITGROUP_LEFTLEG] = "Left Leg",
			[HITGROUP_RIGHTLEG] = "Right Leg",
		},
		bleed = true,
		oxyLoss = true,
	},
}

PLUGIN.parts = {
	[HITGROUP_HEAD] = {
		name = "Head",
		bleed = 0.5, --head is lower since headshots do a ton of damage
	},
	[HITGROUP_CHEST] = {
		name = "Chest",
		oxyLoss = 1.25,
		bleed = 1,
	},
	[HITGROUP_STOMACH] = {
		name = "Stomach",
		bleed = 1,
	},
	[HITGROUP_LEFTARM] = {
		name = "Left Arm",
		bleed = 1,
	},
	[HITGROUP_RIGHTARM] = {
		name = "Right Arm",
		bleed = 1,
	},
	[HITGROUP_LEFTLEG] = {
		name = "Left Leg",
		bleed = 1.25,
	},
	[HITGROUP_RIGHTLEG] = {
		name = "Right Leg",
		bleed = 1.25,
	},
	
	--these shouldnt ever really happen but they're here just in case they do
	[HITGROUP_GENERIC] = {
		name = "Body",
		bleed = 1,
	},
	[HITGROUP_GEAR] = {
		name = "Body",
		bleed = 0.5,
	},
}