ITEM.name = "Standard Heavy Kevlar"
ITEM.desc = "A heavier kevlar vest, used for protection. Has some better leg protection."
ITEM.uniqueID = "armorvestheavy"
ITEM.model = "models/warz/armoredplatevest.mdl"
ITEM.flag = "v"
ITEM.width = 1
ITEM.height = 1
ITEM.armor = 100
ITEM.slot = "Chest"

ITEM.dura = 1000

ITEM.protects = {
	[HITGROUP_HEAD] = 0, --the second value is the percentage defense the item gives from damage, 1 = 100% 0 = 0%
	[HITGROUP_CHEST] = 1,
	[HITGROUP_STOMACH] = 1,
	[HITGROUP_LEFTARM] = 1,
	[HITGROUP_RIGHTARM] = 1,
	[HITGROUP_LEFTLEG] = 0.75,
	[HITGROUP_RIGHTLEG] = 0.75,
}