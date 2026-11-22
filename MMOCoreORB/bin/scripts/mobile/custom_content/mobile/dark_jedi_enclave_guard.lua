-- Guard posted outside the Yavin 4 Dark Jedi Enclave.
-- Belongs to the enclave's own side (Imperial) and is deliberately not
-- AGGRESSIVE: members walking up to the door are not attacked, while the
-- guard still fights back if somebody swings at it.

dark_jedi_enclave_guard = Creature:new {
	objectName = "@mob/creature_names:dark_jedi_sentinel",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	mobType = MOB_NPC,
	socialGroup = "dark_jedi",
	faction = "imperial",
	level = 300,
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

	templates = {
		"object/mobile/dressed_dark_jedi_human_male_01.iff",
		"object/mobile/dressed_dark_jedi_human_female_01.iff"},
	lootGroups = {
		{
			groups = {
				{group = "jedi_comp_group", chance = 10000000},
			},
			lootChance = 600000
		},
		{
			groups = {
				{group = "holocron_dark", chance = 2000000},
				{group = "holocron_light", chance = 2000000},
				{group = "power_crystals", chance = 1000000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000},
				{group = "dark_jedi_common", chance = 1000000}
			},
			lootChance = 10000000
		},
		{
			groups = {
				{group = "nge_all", chance = 10000000},
			},
			lootChance = 10000000
		}
	},
	weapons = {"dark_jedi_weapons_gen4"},
	conversationTemplate = "",
	attacks = merge(lightsabermaster,forcepowermaster)
}

CreatureTemplates:addCreatureTemplate(dark_jedi_enclave_guard, "dark_jedi_enclave_guard")
