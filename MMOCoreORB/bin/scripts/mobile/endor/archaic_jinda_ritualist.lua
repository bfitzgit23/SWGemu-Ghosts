archaic_jinda_ritualist = Creature:new {
	objectName = "@mob/creature_names:archaic_jinda_ritualist",
	socialGroup = "jinda_tribe",
	faction = "",
	level = 41,
	chanceHit = 0.44,
	damageMin = 345,
	damageMax = 400,
	baseXp = 4006,
	baseHAM = 9300,
	baseHAMmax = 11300,
	armor = 0,
	resists = {30,50,-1,30,30,70,30,-1,-1},
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

	templates = {
			"object/mobile/jinda_male.iff",
			"object/mobile/jinda_male_01.iff",
			"object/mobile/jinda_female.iff",
			"object/mobile/jinda_female_01.iff"},
	lootGroups = {
		{
	        groups = {
                {group = "ewok", chance = 3500000}, -- 35.00%
                {group = "wearables_uncommon", chance = 3500000}, -- 35.00%
                {group = "armor_attachments", chance = 1500000}, -- 15.00%
                {group = "clothing_attachments", chance = 1500000}, -- 15.00%
			},
		}
	},
	weapons = {"ewok_weapons"},
	conversationTemplate = "",
	attacks = merge(riflemanmaster,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(archaic_jinda_ritualist, "archaic_jinda_ritualist")
