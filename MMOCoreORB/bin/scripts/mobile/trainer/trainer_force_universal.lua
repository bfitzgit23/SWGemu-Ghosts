-- =============================================================================
-- Ghosts of the Old Republic
-- Universal Force Trainer
-- Trains: Force Sensitive, Jedi disciplines, Grey Jedi (all tiers),
--         Grand Jedi Master, and Dark Jedi Lord
--
-- File:    bin/scripts/mobile/trainer/trainer_force_universal.lua
-- Add to serverobjects.lua:
--   includeFile("mobile/trainer/trainer_force_universal.lua")
-- Spawn in-game: /spawn trainer_force_universal
-- =============================================================================

trainer_force_universal = Creature:new {
	objectName         = "@mob/creature_names:trainer_jedi",
	randomNameType     = NAME_GENERIC,
	randomNameTag      = true,
	planetMapCategory  = "trainer_jedi",
	faction            = "",
	level              = 100,
	chanceHit          = 0.390000,
	damageMin          = 290,
	damageMax          = 300,
	baseXp             = 2914,
	baseHAM            = 8400,
	baseHAMmax         = 10200,
	armor              = 0,
	resists            = {-1,-1,-1,-1,-1,-1,-1,-1,-1},
	meatType           = "",
	meatAmount         = 0,
	hideType           = "",
	hideAmount         = 0,
	boneType           = "",
	boneAmount         = 0,
	milk               = 0,
	tamingChance       = 0.000000,
	ferocity           = 0,
	pvpBitmask         = NONE,
	creatureBitmask    = NONE,
	optionsBitmask     = INVULNERABLE + CONVERSABLE,
	diet               = HERBIVORE,

	templates = {
		"object/mobile/dressed_jedi_trainer_old_human_male_01.iff",
	},

	lootGroups  = {},
	weapons     = {},

	conversationTemplate = "",
	trainerType          = "trainer_force_universal",

	attacks = {}
}

CreatureTemplates:addCreatureTemplate(trainer_force_universal, "trainer_force_universal")
