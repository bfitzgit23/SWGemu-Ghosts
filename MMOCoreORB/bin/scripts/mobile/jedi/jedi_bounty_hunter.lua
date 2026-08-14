-- Coded by BoosterSteel 19-03-2026
-- Custom bounty hunter mobile for Jedi visibility hunters
-- Spawns when player hits 75+ visibility

jedi_bounty_hunter = Creature:new {
	objectName = "@mob/creature_names:bounty_hunter",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "townsperson",
	faction = "townsperson",
	level = 100,
	chanceHit = 1.2,
	damageMin = 750,
	damageMax = 1150,
	baseXp = 10000,
	baseHAM = 30000,
	baseHAMmax = 36000,
	armor = 1,
	resists = {25,25,15,15,15,15,15,-1,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0.0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	templates = {"object/mobile/dressed_bounty_hunter_zabrak_female_01.iff"},
	lootGroups = {},
	weapons = {"pirate_weapons_heavy"},
	conversationTemplate = "",
	attacks = {}
}

CreatureTemplates:addCreatureTemplate(jedi_bounty_hunter, "jedi_bounty_hunter")
