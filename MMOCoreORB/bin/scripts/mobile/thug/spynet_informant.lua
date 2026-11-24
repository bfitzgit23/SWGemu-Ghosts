-- City spynet informant. Imported from SWG Infinity's
-- bin/scripts/mobile/mission/informant_npc.lua (informant_npc_lvl_1): same
-- invulnerable, conversable informant, but named so a mayor knows what it is.
spynet_informant = Creature:new {
	objectName = "@mob/creature_names:spynet_operative",
	customName = "Spynet Informant",
	socialGroup = "",
	faction = "",
	mobType = MOB_NPC,
	level = 100,
	chanceHit = 0.39,
	damageMin = 290,
	damageMax = 300,
	baseXp = 2914,
	baseHAM = 8400,
	baseHAMmax = 10200,
	armor = 0,
	resists = {-1,-1,-1,-1,-1,-1,-1,-1,-1},
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

	templates = {"object/mobile/dressed_hutt_informant_quest.iff"},
	lootGroups = {},

	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "informant_npc_lvl_1",

	primaryAttacks = { {"",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(spynet_informant, "spynet_informant")
