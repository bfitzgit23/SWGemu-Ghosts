-- Guard posted outside the Yavin 4 Light Jedi Enclave.
-- Belongs to the enclave's own side (Rebel) and is deliberately not
-- AGGRESSIVE: members walking up to the door are not attacked, while the
-- guard still fights back if somebody swings at it.

light_jedi_enclave_guard = Creature:new {
	objectName = "@mob/creature_names:light_jedi_sentinel",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	mobType = MOB_NPC,
	socialGroup = "jedi",
	faction = "rebel",
	level = 1,
	chanceHit = 30,
	damageMin = 2645,
	damageMax = 5000,
	baseXp = 45,
	baseHAM = 1106000,
	baseHAMmax = 1352000,
	armor = 3,
	resists = {95,95,95,95,95,95,95,95,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = { "light_jedi" },
	lootGroups = {},

	weapons = {"light_jedi_weapons"},
	conversationTemplate = "",
	attacks = merge(lightsabermaster,forcepowermaster)
}

CreatureTemplates:addCreatureTemplate(light_jedi_enclave_guard, "light_jedi_enclave_guard")
