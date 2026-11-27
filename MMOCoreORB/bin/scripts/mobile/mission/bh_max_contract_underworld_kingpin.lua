-- Ghosts: maximum-tier bounty contract target (CL 900).
bh_max_contract_underworld_kingpin = Creature:new {
	objectName = "@mob/creature_names:crimelord",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	mobType = MOB_NPC,
	socialGroup = "criminal",
	faction = "",
	level = 900,
	chanceHit = 42.00,
	damageMin = 3900,
	damageMax = 7000,
	baseXp = 620000,
	baseHAM = 600000,
	baseHAMmax = 780000,
	armor = 3,
	resists = {82,82,82,82,82,82,82,82,-1},
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
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	templates = {"object/mobile/dressed_criminal_slicer_human_male_01.iff"},
	lootGroups = {
		{
			groups = {
				{group = "junk",        chance = 2000000},
				{group = "armor_all",   chance = 3000000},
				{group = "weapons_all", chance = 2500000},
				{group = "tierone",     chance = 1500000},
				{group = "tiertwo",     chance = 1000000}
			},
			lootChance = 10000000
		},
		{
			groups = {
				{group = "wearables_all",     chance = 3000000},
				{group = "loot_kit_parts",    chance = 1500000},
				{group = "tailor_components", chance = 1500000},
				{group = "color_crystals",    chance = 2000000},
				{group = "power_crystals",    chance = 2000000}
			},
			lootChance = 10000000
		},
		{
			groups = {
				{group = "tierone",    chance = 2500000},
				{group = "tiertwo",    chance = 2500000},
				{group = "tierthree",  chance = 3000000},
				{group = "tierdiamond",chance = 2000000}
			},
			lootChance = 10000000
		},
	},
	primaryWeapon = "pirate_weapons_heavy",
	secondaryWeapon = "unarmed",
	conversationTemplate = "",
	primaryAttacks = merge(brawlermaster,marksmanmaster),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(bh_max_contract_underworld_kingpin, "bh_max_contract_underworld_kingpin")
