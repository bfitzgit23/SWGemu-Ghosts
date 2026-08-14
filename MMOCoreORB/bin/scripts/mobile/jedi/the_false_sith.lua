-- Deploy to: MMOCoreORB/bin/scripts/mobile/thug/the_false_sith.lua
-- Add to serverobjects.lua: includeFile("mobile/thug/the_false_sith.lua")
-- Coded by BoosterSteel 19-03-2026

the_false_sith = Creature:new {
	objectName = "@mob/creature_names:the_false_sith",
	customName = "The False Sith",
	randomNameType = NAME_GENERIC,
	randomNameTag = false,
	socialGroup = "force",
	faction = "",
	level = 90,
	chanceHit = 0.9,
	damageMin = 640,
	damageMax = 990,
	baseXp = 8593,
	baseHAM = 13000,
	baseHAMmax = 16000,
	armor = 2,
	resists = {45,45,0,0,0,0,0,0,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0.0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/dressed_force_trained_archaist.iff"},
	lootGroups = {
		{
			groups = {
				{group = "junk",                 chance = 3500000},
				{group = "power_crystals",       chance = 500000},
				{group = "color_crystals",       chance = 500000},
				{group = "holocron_dark",        chance = 500000},
				{group = "holocron_light",       chance = 500000},
				{group = "melee_weapons",        chance = 1000000},
				{group = "armor_attachments",    chance = 1000000},
				{group = "clothing_attachments", chance = 1000000},
				{group = "wearables_common",     chance = 750000},
				{group = "wearables_uncommon",   chance = 750000},
			}
		}
	},
	weapons = {"mixed_force_weapons"},
	conversationTemplate = "",
	attacks = merge(pikemanmaster, brawlermaster)
}

CreatureTemplates:addCreatureTemplate(the_false_sith, "the_false_sith")
