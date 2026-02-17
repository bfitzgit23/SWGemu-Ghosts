-- ============================================================
-- Grand Jedi Master Trainer - NPC Mobile Template
-- Path: scripts/mobile/trainer/trainer_grand_jedi_master.lua
-- Uses Jedi trainer appearance (old man jedi robes)
-- ============================================================

trainer_grand_jedi_master = Creature:new {
	objectName = "@mob/creature_names:trainer_grand_jedi_master",
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
		"object/mobile/dressed_jedi_trainer_chiss_male_01.iff",
		"object/mobile/dressed_jedi_trainer_twilek_female_01.iff",
		"object/mobile/dressed_jedi_trainer_old_human_male_01.iff",
	},
	lootGroups = {},
	weapons = {},
	conversationTemplate = "trainer_grand_jedi_master_convotemplate",
	attacks = {}
}

CreatureTemplates:addCreatureTemplate(trainer_grand_jedi_master, "trainer_grand_jedi_master")
