som_ancient_guardian_droideka = Creature:new {
	customName = "Ancient Guardian Droideka",
	socialGroup = "townsperson",
	faction = "",
	level = 70,
	chanceHit = 0.27,
	damageMin = 550,
	damageMax = 800,
	baseXp = 235,
	baseHAM = 16000,
	baseHAMmax = 19000,
	armor = 0,
	resists = {0,0,0,0,0,0,0,-1,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0.0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/som_ancient_guardian_droideka.iff"},
	lootGroups = {
		{
			groups = {
				{group = "mustafar_glowing", chance = 10000000},
			},
			lootChance = 800000
		},
		{
			groups = {},
			lootChance = 2100000
		}
	},
	weapons = {"droideka_weapons"},
	conversationTemplate = "",
	attacks = merge(marksmannovice,brawlernovice)
}

CreatureTemplates:addCreatureTemplate(som_ancient_guardian_droideka, "som_ancient_guardian_droideka")
