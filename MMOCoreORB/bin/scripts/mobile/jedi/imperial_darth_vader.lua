-- Coded by BoosterSteel 19-03-2026
-- Custom Darth Vader mobile for Imperial squad hunter
-- Spawns at FRS rank 8+

imperial_darth_vader = Creature:new {
	objectName = "Darth Vader",
	customName = "Darth Vader",
	randomNameType = NAME_GENERIC,
	randomNameTag = false,
	socialGroup = "imperial",
	faction = "imperial",
	level = 200,
	chanceHit = 2.5,
	damageMin = 2000,
	damageMax = 3500,
	baseXp = 25000,
	baseHAM = 170000,
	baseHAMmax = 193000,
	armor = 3,
	resists = {50,50,50,50,50,50,50,50,50},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0.0,
	ferocity = 10,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	templates = {"object/mobile/darth_vader.iff"},
	lootGroups = {},
	weapons = {"jedi_weapons_gen4"},
	conversationTemplate = "",
	attacks = {
		{"intimidationattack", "50"},
		{"forcechoke", "50"},
	}
}

CreatureTemplates:addCreatureTemplate(imperial_darth_vader, "imperial_darth_vader")
