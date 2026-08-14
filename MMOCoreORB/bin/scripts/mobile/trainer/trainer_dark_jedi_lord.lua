-- ============================================================
-- Dark Jedi Lord Trainer - NPC Mobile Template
-- Path: scripts/mobile/trainer/trainer_dark_jedi_lord.lua
-- Uses dark Jedi trainer appearance
-- ============================================================

trainer_dark_jedi_lord = Creature:new {
	objectName = "@mob/creature_names:trainer_dark_jedi_lord",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "trainer",
	faction = "",
	level = 1,
	chanceHit = 1,
	damageMin = 50,
	damageMax = 100,
	baseXp = 0,
	baseHAM = 2400,
	baseHAMmax = 2400,
	armor = 0,
	resists = {0, 0, 0, 0, 0, 0, 0, -1, -1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = INVULNERABLE + CONVERSABLE,
	diet = HERBIVORE,

	templates = {
		"object/mobile/dressed_dark_jedi_male_human_01.iff",
		"object/mobile/dressed_dark_jedi_female_human_01.iff",
		"object/mobile/dressed_dark_jedi_male_zab_01.iff",
	},
	lootGroups = {},
	weapons = {},
	conversationTemplate = "trainer_dark_jedi_lord_convotemplate",
	attacks = {}
}

CreatureTemplates:addCreatureTemplate(trainer_dark_jedi_lord, "trainer_dark_jedi_lord")
