local ghostsForceRobeNames = {
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

local robeLootItems = {}
local baseWeight = math.floor(10000000 / #ghostsForceRobeNames)
local remainingWeight = 10000000

for index, robeName in ipairs(ghostsForceRobeNames) do
	local weight = index == #ghostsForceRobeNames and remainingWeight or baseWeight
	table.insert(robeLootItems, {itemTemplate = "ghosts_custom_" .. robeName, weight = weight})
	remainingWeight = remainingWeight - weight
end

ghosts_force_robes = {
	description = "Ghosts custom fixed-stat Force robes",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = robeLootItems,
}

addLootGroupTemplate("ghosts_force_robes", ghosts_force_robes)
