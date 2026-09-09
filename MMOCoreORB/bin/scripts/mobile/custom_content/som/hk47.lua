hk47 = Creature:new {
	customName = "HK-47",
	socialGroup = "townsperson",
	faction = "",
	level = 250,
	chanceHit = 25.0,
	damageMin = 2250,
	damageMax = 3470,
	baseXp = 25000,
	baseHAM = 400000,
	baseHAMmax = 500000,
	armor = 1,
	resists = {85,85,85,85,85,85,85,85,-1},
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
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/shared_hk47.iff"},
	lootGroups = {
		{
			groups = {
				{group = "hk47_loot", chance = 10000000},
			},
			lootChance = 2100000
		}
	},
	weapons = {"pirate_weapons_light"},
	conversationTemplate = "",
	attacks = merge(marksmannovice,brawlernovice)
}

CreatureTemplates:addCreatureTemplate(hk47, "hk47")
