-- Coded by BoosterSteel 19-03-2026
-- Custom black stormtrooper for Imperial squad hunter

imperial_black_stormtrooper = Creature:new {
	objectName = "Imperial Shadow Guard",
	customName = "Imperial Shadow Guard",
	randomNameType = NAME_GENERIC,
	randomNameTag = false,
	socialGroup = "imperial",
	faction = "imperial",
	level = 175,
	chanceHit = 2.0,
	damageMin = 1500,
	damageMax = 2500,
	baseXp = 15000,
	baseHAM = 130000,
	baseHAMmax = 148000,
	armor = 2,
	resists = {40,40,35,35,35,35,35,35,35},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0.0,
	ferocity = 8,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	templates = {"object/mobile/dressed_stormtrooper_black_black.iff"},
	lootGroups = {},
	weapons = {"imperial_weapons_heavy"},
	conversationTemplate = "",
	attacks = {}
}

CreatureTemplates:addCreatureTemplate(imperial_black_stormtrooper, "imperial_black_stormtrooper")
