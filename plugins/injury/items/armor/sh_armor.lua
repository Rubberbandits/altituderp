ITEM.name = "Armor Example"
ITEM.desc = "An item to test armor."
ITEM.uniqueID = "armorexample"
ITEM.model = "models/props_junk/cardboard_box004a.mdl"
ITEM.flag = "v"
ITEM.width = 1
ITEM.height = 1
ITEM.armor = 100
ITEM.slot = "Helmet"

ITEM.dura = 100

ITEM.protects = {
	[HITGROUP_HEAD] = 1, --the second value is the percentage defense the item gives from damage, 1 = 100% 0 = 0%
	[HITGROUP_CHEST] = 1,
	[HITGROUP_STOMACH] = 1,
	[HITGROUP_LEFTARM] = 1,
	[HITGROUP_RIGHTARM] = 1,
	[HITGROUP_LEFTLEG] = 0.2,
	[HITGROUP_RIGHTLEG] = 0.2,
}