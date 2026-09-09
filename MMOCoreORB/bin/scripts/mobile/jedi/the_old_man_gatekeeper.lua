-- Deploy to: MMOCoreORB/bin/scripts/mobile/jedi/the_old_man_gatekeeper.lua
-- Add to serverobjects.lua: includeFile("mobile/jedi/the_old_man_gatekeeper.lua")
-- Coded by BoosterSteel 19-03-2026

the_old_man_gatekeeper = Creature:new {
	objectName = "@mob/creature_names:the_old_man_gatekeeper",
	customName = "The Gatekeeper",
	randomNameType = NAME_GENERIC,
	randomNameTag = false,
	socialGroup = "neutral",   -- must be neutral, not "force" which can trigger aggro AI
	faction = "",
	level = 1,
	chanceHit = 0.0,
	damageMin = 0,
	damageMax = 0,
	baseXp = 0,
	baseHAM = 1000,
	baseHAMmax = 1000,
	armor = 0,
	resists = {0,0,0,0,0,0,0,0,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0.0,
	ferocity = 0,
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED + CONVERSABLE,
	diet = HERBIVORE,

	templates = {"object/mobile/dressed_fs_village_oldman.iff"},
	lootGroups = {},
	weapons = {},
	conversationTemplate = "GatekeeperTrialConvoTemplate",
	attacks = {}
}

CreatureTemplates:addCreatureTemplate(the_old_man_gatekeeper, "the_old_man_gatekeeper")
