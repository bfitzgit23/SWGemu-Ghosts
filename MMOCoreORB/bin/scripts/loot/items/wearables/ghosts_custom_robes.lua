-- Fixed-stat robe templates migrated from Ghosts_old. The actual bonuses live
-- on the tangible object templates, so these loot entries intentionally do
-- not generate random skill mods or crafting values.
local ghostsCustomRobeObjects = {
	"robe_jedi_black_01", "robe_jedi_black_02",
	"robe_jedi_tan_01", "robe_jedi_tan_02",
	"robe_jedi_gray_01", "robe_jedi_gray_02",
	"robe_s32", "robe_s32_h1", "robe_s33", "robe_s33_h1",
	"robe_revan", "robe_atris", "robe_starforge", "robe_swtor",
	"robe_jedi_sith2_s01", "robe_jedi_sith2_s02", "robe_jedi_sith2_s03", "robe_jedi_sith2_s04", "robe_jedi_sith2_s05",
	"robe_jedi_grey2_s01", "robe_jedi_grey2_s02", "robe_jedi_grey2_s03", "robe_jedi_grey2_s04", "robe_jedi_grey2_s05",
	"robe_jedi_dark2_s01", "robe_jedi_dark2_s02", "robe_jedi_dark2_s03", "robe_jedi_dark2_s04", "robe_jedi_dark2_s05",
	"robe_jedi_light2_s01", "robe_jedi_light2_s02", "robe_jedi_light2_s03", "robe_jedi_light2_s04", "robe_jedi_light2_s05",
	"robe_jedi_sith_s01", "robe_jedi_sith_s02", "robe_jedi_sith_s03", "robe_jedi_sith_s04", "robe_jedi_sith_s05",
	"robe_jedi_grey_s01", "robe_jedi_grey_s02", "robe_jedi_grey_s03", "robe_jedi_grey_s04", "robe_jedi_grey_s05",
}

local ghostsCustomRobeSkillMods = {
	robe_revan = {
		{"force_control_dark", 25},
		{"force_power_dark", 25},
		{"force_manipulation_dark", 25},
		{"jedi_force_power_regen", 25},
		{"jedi_force_power_max", 500},
	},
	robe_starforge = {
		{"force_control_light", 25},
		{"force_power_light", 25},
		{"force_manipulation_light", 25},
		{"jedi_force_power_regen", 25},
		{"jedi_force_power_max", 500},
	},
}

for _, objectName in ipairs(ghostsCustomRobeObjects) do
	local templateName = "ghosts_custom_" .. objectName
	local lootTemplate = {
		minimumLevel = 0,
		maximumLevel = -1,
		customObjectName = "",
		directObjectTemplate = "object/tangible/wearables/robe/" .. objectName .. ".iff",
		craftingValues = {},
		skillMods = ghostsCustomRobeSkillMods[objectName] or {},
		customizationStringNames = {},
		customizationValues = {},
		junkDealerTypeNeeded = JUNKCLOTHESANDJEWELLERY,
		junkMinValue = 55,
		junkMaxValue = 110,
	}

	addLootItemTemplate(templateName, lootTemplate)
end
