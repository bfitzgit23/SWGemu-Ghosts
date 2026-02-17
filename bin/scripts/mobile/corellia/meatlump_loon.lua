meatlump_loon = Creature:new {
	objectName = "@mob/creature_names:meatlump_loon",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "meatlump",
	faction = "meatlump",
	level = 10,
	chanceHit = 0.28,
	damageMin = 90,
	damageMax = 110,
	baseXp = 356,
	baseHAM = 810,
	baseHAMmax = 990,
	armor = 0,
	resists = {0,0,0,0,0,0,0,-1,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK,
	diet = HERBIVORE,

	templates = {
		"object/mobile/dressed_gran_thug_male_01.iff",
		"object/mobile/dressed_gran_thug_male_02.iff",
		"object/mobile/dressed_criminal_thug_aqualish_female_01.iff",
		"object/mobile/dressed_criminal_thug_aqualish_female_02.iff",
		"object/mobile/dressed_criminal_thug_aqualish_male_01.iff",
		"object/mobile/dressed_criminal_thug_aqualish_male_02.iff"},
	lootGroups = {
		{
			groups = {
                {group = "color_crystals", chance = 1500000}, -- 15.00%
                {group = "junk", chance = 2125000}, -- 21.25%
                {group = "loot_kit_parts", chance = 2125000}, -- 21.25%
                {group = "tailor_components", chance = 2125000}, -- 21.25%
                {group = "meatlump_common", chance = 2125000}, -- 21.25%
			}
		}
	},
	weapons = {"pirate_weapons_light"},
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlernovice,marksmannovice)
}

CreatureTemplates:addCreatureTemplate(meatlump_loon, "meatlump_loon")
