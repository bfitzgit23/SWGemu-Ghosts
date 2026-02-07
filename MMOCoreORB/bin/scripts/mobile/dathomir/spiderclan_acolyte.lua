spiderclan_acolyte = Creature:new {
	objectName = "@mob/creature_names:spider_nightsister_initiate",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "spider_nightsister",
	faction = "spider_nightsister",
	level = 64,
	chanceHit = 0.5,
	damageMin = 445,
	damageMax = 600,
	baseXp = 6196,
	baseHAM = 11000,
	baseHAMmax = 14000,
	armor = 1,
	resists = {35,85,100,50,100,100,50,100,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/dressed_dathomir_spider_nightsister_initiate.iff"},
	lootGroups = {
		{
			groups = {
                {group = "junk", chance = 2250000}, -- 22.50%
                {group = "power_crystals", chance = 750000}, -- 7.50%
                {group = "color_crystals", chance = 750000}, -- 7.50%
                {group = "armor_attachments", chance = 750000}, -- 7.50%
                {group = "clothing_attachments", chance = 750000}, -- 7.50%
                {group = "melee_weapons", chance = 500000}, -- 5.00%
                {group = "pistols", chance = 500000}, -- 5.00%
                {group = "rifles", chance = 500000}, -- 5.00%
                {group = "carbines", chance = 500000}, -- 5.00%
                {group = "wearables_common", chance = 500000}, -- 5.00%
                {group = "wearables_uncommon", chance = 2250000}, -- 22.50%
			}
		}
	},
	weapons = {"mixed_force_weapons"},
	conversationTemplate = "",
	attacks = merge(brawlermaster,pikemanmaster)
}

CreatureTemplates:addCreatureTemplate(spiderclan_acolyte, "spiderclan_acolyte")
