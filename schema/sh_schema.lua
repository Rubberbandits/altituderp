SCHEMA.name = "Shattered Warfare"
SCHEMA.introName = "Shattered Roleplay"
SCHEMA.desc = "Kiev, Ukraine - 2030"
SCHEMA.author = "westford"

function SCHEMA:GetGameDescription()
	return "NS - "..self.name
end

hook.Add('ShouldDrawCrosshair', 'DisableCrosshair', function()
  return false
end)

--always raised stuff
ALWAYS_RAISED["cw_ak74"] = true
ALWAYS_RAISED["cw_ar15"] = true
ALWAYS_RAISED["cw_extrema_ratio_official"] = true
ALWAYS_RAISED["cw_flash_grenade"] = true
ALWAYS_RAISED["cw_fiveseven"] = true
ALWAYS_RAISED["cw_scarh"] = true
ALWAYS_RAISED["cw_frag_grenade"] = true
ALWAYS_RAISED["cw_mp5"] = true
ALWAYS_RAISED["cw_l115"] = true
ALWAYS_RAISED["cw_m1911"] = true
ALWAYS_RAISED["cw_deagle"] = true
ALWAYS_RAISED["cw_m249_official"] = true
ALWAYS_RAISED["cw_m3super90"] = true
ALWAYS_RAISED["cw_mr96"] = true
ALWAYS_RAISED["cw_p99"] = true
ALWAYS_RAISED["cw_makarov"] = true
ALWAYS_RAISED["cw_smoke_grenade"] = true
ALWAYS_RAISED["ins2_atow_rpg7"] = true


nut.currency.set("", "Ration Token", "Ration Tokens")

nut.util.include("cl_effects.lua")
nut.util.include("sh_commands.lua")
nut.util.includeDir("libs")
nut.util.includeDir("hooks")
nut.util.includeDir("derma")

--blacklight models
nut.anim.setModelClass("models/russianbear2345/bf3/engie_ru.mdl", "player")
nut.anim.setModelClass("models/russianbear2345/bf3/medic_ru.mdl", "player")
nut.anim.setModelClass("models/russianbear2345/bf3/support_ru.mdl", "player")
nut.anim.setModelClass("models/russianbear2345/bf3/alternate/medic_ru.mdl", "player")
nut.anim.setModelClass("models/russianbear2345/bf3/alternate/support_ru.mdl", "player")
nut.anim.setModelClass("models/shattered/sky/wec/male.mdl", "player")
nut.anim.setModelClass("models/shattered/sky/wec/female.mdl", "player")





--Smalls civ Male

nut.anim.setModelClass("models/smalls_civilians/pack2/male/baseballtee/male_01_baseballtee_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/baseballtee/male_02_baseballtee_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/baseballtee/male_03_baseballtee_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/baseballtee/male_04_baseballtee_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/baseballtee/male_05_baseballtee_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/baseballtee/male_06_baseballtee_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/baseballtee/male_07_baseballtee_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/baseballtee/male_08_baseballtee_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/baseballtee/male_09_baseballtee_pm.mdl", "player")

nut.anim.setModelClass("models/smalls_civilians/pack2/male/flannel/male_01_flannel_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/flannel/male_02_flannel_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/flannel/male_03_flannel_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/flannel/male_04_flannel_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/flannel/male_05_flannel_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/flannel/male_06_flannel_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/flannel/male_07_flannel_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/flannel/male_08_flannel_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/flannel/male_09_flannel_pm.mdl", "player")

nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_jeans/male_01_hoodiejeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_jeans/male_02_hoodiejeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_jeans/male_03_hoodiejeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_jeans/male_04_hoodiejeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_jeans/male_05_hoodiejeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_jeans/male_06_hoodiejeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_jeans/male_07_hoodiejeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_jeans/male_08_hoodiejeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_jeans/male_09_hoodiejeans_pm.mdl", "player")

nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_sweatpants/male_01_hoodiesweatpants_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_sweatpants/male_02_hoodiesweatpants_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_sweatpants/male_03_hoodiesweatpants_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_sweatpants/male_04_hoodiesweatpants_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_sweatpants/male_05_hoodiesweatpants_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_sweatpants/male_06_hoodiesweatpants_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_sweatpants/male_07_hoodiesweatpants_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_sweatpants/male_08_hoodiesweatpants_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/hoodie_sweatpants/male_09_hoodiesweatpants_pm.mdl", "player")

nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacket_open/male_01_jacketopen_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacket_open/male_02_jacketopen_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacket_open/male_03_jacketopen_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacket_open/male_04_jacketopen_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacket_open/male_05_jacketopen_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacket_open/male_06_jacketopen_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacket_open/male_07_jacketopen_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacket_open/male_08_jacketopen_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacket_open/male_09_jacketopen_pm.mdl", "player")

nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacketvneck_sweatpants/male_01_jacketvneck_sweatpants_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacketvneck_sweatpants/male_02_jacketvneck_sweatpants_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacketvneck_sweatpants/male_03_jacketvneck_sweatpants_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacketvneck_sweatpants/male_04_jacketvneck_sweatpants_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacketvneck_sweatpants/male_05_jacketvneck_sweatpants_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacketvneck_sweatpants/male_06_jacketvneck_sweatpants_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacketvneck_sweatpants/male_07_jacketvneck_sweatpants_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacketvneck_sweatpants/male_08_jacketvneck_sweatpants_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/jacketvneck_sweatpants/male_09_jacketvneck_sweatpants_pm.mdl", "player")

nut.anim.setModelClass("models/smalls_civilians/pack2/male/leatherjacket/male_01_leather_jacket_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/leatherjacket/male_02_leather_jacket_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/leatherjacket/male_02_leather_jacket_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/leatherjacket/male_03_leather_jacket_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/leatherjacket/male_04_leather_jacket_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/leatherjacket/male_05_leather_jacket_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/leatherjacket/male_06_leather_jacket_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/leatherjacket/male_07_leather_jacket_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/male/leatherjacket/male_08_leather_jacket_pm.mdl", "player")

--smalls civ female

nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiepulloverjeans/female_01_hoodiepulloverjeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiepulloverjeans/female_02_hoodiepulloverjeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiepulloverjeans/female_03_hoodiepulloverjeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiepulloverjeans/female_04_hoodiepulloverjeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiepulloverjeans/female_06_hoodiepulloverjeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiepulloverjeans/female_07_hoodiepulloverjeans_pm.mdl", "player")

nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiepulloversweats/female_01_hoodiepulloversweats_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiepulloversweats/female_02_hoodiepulloversweats_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiepulloversweats/female_03_hoodiepulloversweats_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiepulloversweats/female_04_hoodiepulloversweats_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiepulloversweats/female_06_hoodiepulloversweats_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiepulloversweats/female_07_hoodiepulloversweats_pm.mdl", "player")

nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiezippedjeans/female_01_hoodiezippedjeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiezippedjeans/female_02_hoodiezippedjeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiezippedjeans/female_03_hoodiezippedjeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiezippedjeans/female_04_hoodiezippedjeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiezippedjeans/female_06_hoodiezippedjeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiezippedjeans/female_07_hoodiezippedjeans_pm.mdl", "player")

nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiezippedsweats/female_01_hoodiezippedsweats_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiezippedsweats/female_02_hoodiezippedsweats_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiezippedsweats/female_03_hoodiezippedsweats_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiezippedsweats/female_04_hoodiezippedsweats_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiezippedsweats/female_06_hoodiezippedsweats_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/hoodiezippedsweats/female_07_hoodiezippedsweats_pm.mdl", "player")

nut.anim.setModelClass("models/smalls_civilians/pack2/female/parkajeans/female_01_parkajeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/parkajeans/female_02_parkajeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/parkajeans/female_03_parkajeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/parkajeans/female_04_parkajeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/parkajeans/female_06_parkajeans_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/parkajeans/female_07_parkajeans_pm.mdl", "player")

nut.anim.setModelClass("models/smalls_civilians/pack2/female/parkasweats/female_01_parkasweats_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/parkasweats/female_02_parkasweats_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/parkasweats/female_03_parkasweats_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/parkasweats/female_04_parkasweats_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/parkasweats/female_06_parkasweats_pm.mdl", "player")
nut.anim.setModelClass("models/smalls_civilians/pack2/female/parkasweats/female_07_parkasweats_pm.mdl", "player")

--This is used for some entities to print stuff in the chat to people.
nut.chat.register("mind", {
	onChatAdd = function(speaker, text)
		local color = nut.chat.classes.ic.onGetColor(speaker, text)
		chat.AddText(Color(115, 115, 115), "**\""..text.."\"")
	end,
	onCanHear = 1, --range is set incredibly low so that only the client can see it.
	prefix = {"/mind"},
	font = "nutChatFontItalics",
	filter = "actions",
	deadCanChat = true
})