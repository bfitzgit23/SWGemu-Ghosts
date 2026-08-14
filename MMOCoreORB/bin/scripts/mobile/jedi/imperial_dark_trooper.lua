-- Coded by BoosterSteel 19-03-2026
-- Custom dark trooper for Imperial squad hunter

imperial_dark_trooper = Creature:new {
	objectName = "Dark Trooper",
	customName = "Dark Trooper",
	randomNameType = NAME_GENERIC,
	randomNameTag = false,
	socialGroup = "imperial",
	faction = "imperial",
	level = 150,
	chanceHit = 1.8,
	damageMin = 1200,
	damageMax = 2000,
	baseXp = 12000,
	baseHAM = 108000,
	baseHAMmax = 122000,
	armor = 2,
	resists = {35,35,30,30,30,30,30,30,30},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0.0,
	ferocity = 6,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	templates = {"object/mobile/dark_trooper.iff"},
	lootGroups = {},
	weapons = {"imperial_weapons_heavy"},
	conversationTemplate = "",
	attacks = {}
}

CreatureTemplates:addCreatureTemplate(imperial_dark_trooper, "imperial_dark_trooper")
