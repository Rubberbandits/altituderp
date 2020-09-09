ITEM.name = "Standard Issued Kevlar"
ITEM.desc = "A standard issued kevlar vest, used for protection."
ITEM.uniqueID = "armorvest"
ITEM.model = "models/warz/armoredplatevest.mdl"
ITEM.flag = "v"
ITEM.width = 1
ITEM.height = 1
ITEM.armor = 100
ITEM.slot = "Chest"

ITEM.dura = 800

ITEM.protects = {
	[HITGROUP_HEAD] = 0, --the second value is the percentage defense the item gives from damage, 1 = 100% 0 = 0%
	[HITGROUP_CHEST] = 1,
	[HITGROUP_STOMACH] = 1,
	[HITGROUP_LEFTARM] = 1,
	[HITGROUP_RIGHTARM] = 1,
	[HITGROUP_LEFTLEG] = 0.5,
	[HITGROUP_RIGHTLEG] = 0.5,
}