wise_jinda_ritualist = Creature:new {
	objectName = "@mob/creature_names:wise_jinda_ritualist",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "jinda_tribe",
	faction = "",
	level = 35,
	chanceHit = 0.41,
	damageMin = 320,
	damageMax = 350,
	baseXp = 3460,
	baseHAM = 8800,
	baseHAMmax = 10800,
	armor = 0,
	resists = {25,25,25,25,25,25,25,25,-1},
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
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/jinda_male.iff",
		"object/mobile/jinda_female.iff",
		"object/mobile/jinda_male_01.iff",
		"object/mobile/jinda_female_01.iff"},

	lootGroups = {
		{
			groups = {
                {group = "ewok", chance = 3500000}, -- 35.00%
                {group = "wearables_uncommon", chance = 3500000}, -- 35.00%
                {group = "armor_attachments", chance = 1500000}, -- 15.00%
                {group = "clothing_attachments", chance = 1500000}, -- 15.00%
			},
		},
	},
	weapons = {"ewok_weapons"},
	conversationTemplate = "",
	attacks = merge(riflemanmaster,brawlermaster)

}

CreatureTemplates:addCreatureTemplate(wise_jinda_ritualist, "wise_jinda_ritualist")
