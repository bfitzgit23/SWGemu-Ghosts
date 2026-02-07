forsaken_force_drifter = Creature:new {
	objectName = "@mob/creature_names:forsaken_force_drifter",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "force",
	faction = "",
	level = 80,
	chanceHit = 0.8,
	damageMin = 625,
	damageMax = 960,
	baseXp = 7668,
	baseHAM = 11000,
	baseHAMmax = 14000,
	armor = 1,
	resists = {35,35,35,35,35,35,35,35,-1},
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

	templates = {"object/mobile/dressed_forsaken_force_drifter.iff"},
	lootGroups = {
		{
			groups = {
                {group = "junk", chance = 3322223}, -- 33.22%
                {group = "power_crystals", chance = 822223}, -- 8.22%
                {group = "color_crystals", chance = 822222}, -- 8.22%
                {group = "holocron_dark", chance = 300000}, -- 3.00%
                {group = "holocron_light", chance = 300000}, -- 3.00%
                {group = "melee_weapons", chance = 697222}, -- 6.97%
                {group = "armor_attachments", chance = 822222}, -- 8.22%
                {group = "clothing_attachments", chance = 822222}, -- 8.22%
                {group = "wearables_common", chance = 697222}, -- 6.97%
                {group = "wearables_uncommon", chance = 697222}, -- 6.97%
                {group = "force_hunter_rare", chance = 697222}, -- 6.97%
			}
		}
	},
	weapons = {"mixed_force_weapons"},
	conversationTemplate = "",
	attacks = merge(pikemanmaster,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(forsaken_force_drifter, "forsaken_force_drifter")
