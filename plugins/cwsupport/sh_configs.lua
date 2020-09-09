PLUGIN.gunData = {}
PLUGIN.modelCam = {}
PLUGIN.slotCategory = {
	[1] = "secondary",
	[2] = "primary",
	[3] = "primary",
	[4] = "primary",
}

-- I don't want to make them to buy 50 different kind of ammo
PLUGIN.changeAmmo = {
	["7.92x33mm Kurz"] = "ar2",
	["300 AAC Blackout"] = "ar2",
	["5.7x28mm"] = "ar2",
	["7.62x25mm Tokarev"] = "smg1",
	[".50 BMG"] = "ar2",
	["5.56x45mm"] = "ar2",
	["7.62x51mm"] = "ar2",
	["7.62x31mm"] = "ar2",
	["Frag Grenades"] = "grenade",
	["Flash Grenades"] = "grenade",
	["Smoke Grenades"] = "grenade",
	["9x17MM"] = "pistol",
	["9x19MM"] = "pistol",
	["9x19mm"] = "pistol",
	[".45 ACP"] = "pistol",
	["9x18MM"] = "pistol",
	["9x39MM"] = "pistol",
	[".40 S&W"] = "pistol",
	[".44 Magnum"] = "357",
	[".50 AE"] = "357",
	["5.45x39MM"] = "ar2",
	["5.56x45MM"] = "ar2",
	["5.7x28MM"] = "ar2",
	["7.62x51MM"] = "ar2",
	["7.62x54mmR"] = "ar2",
	["12 Gauge"] = "buckshot",
	[".338 Lapua"] = "sniperround",
}

local AMMO_BOX = "models/sirgibs/weapons/r6vegas/sm_mp5n_magazine.mdl"
local AMMO_CASE = "models/sirgibs/weapons/r6vegas/pi_bull_speedloader.mdl"
local AMMO_FLARE = "models/sirgibs/weapons/r6vegas/pi_p99_magazine.mdl"
local AMMO_BIGBOX = "models/sirgibs/weapons/r6vegas/ar_m468_magazine.mdl"
local AMMO_BUCKSHOT = "models/Items/BoxBuckshot.mdl"
local AMMO_GREN = "models/Items/AR2_Grenade.mdl"

PLUGIN.ammoInfo = {}
PLUGIN.ammoInfo["pistol"] = {
	name = "Pistol Magazine",
	amount = 15,
	price = 200,
	weight = 3,
	model = AMMO_FLARE,
}
PLUGIN.ammoInfo["357"] = {
	name = "Magnum Speed Loader",
	amount = 6,
	price = 350,
	model = AMMO_CASE,
}
PLUGIN.ammoInfo["smg1"] = {
	name = "Submachine Gun Magazine",
	amount = 30,
	price = 400,
	model = AMMO_BOX,
}
PLUGIN.ammoInfo["ar2"] = {
	name = "Assault Rifle Magazine",
	amount = 30,
	price = 400,
	model = AMMO_BIGBOX,
}
PLUGIN.ammoInfo["buckshot"] = {
	name = "Shotgun Shells",
	amount = 10,
	price = 300,
	model = AMMO_BUCKSHOT,
}
PLUGIN.ammoInfo["sniperround"] = {
	name = "Long Rifle Magazine",
	amount = 12,
	price = 500,
	model = AMMO_BIGBOX,
	iconCam = {
		ang	= Angle(8.4998140335083, 170.05499267578, 0),
		fov	= 2.1218640972135,
		pos	= Vector(281.19021606445, -49.330429077148, 45.772754669189)
	}
}

nut.util.include("presets/sh_defcw.lua")
nut.util.include("presets/sh_customweapons.lua")

