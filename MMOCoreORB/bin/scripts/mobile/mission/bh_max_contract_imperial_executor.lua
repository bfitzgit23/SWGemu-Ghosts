-- Ghosts: maximum-tier bounty contract target (CL 900).
bh_max_contract_imperial_executor = Creature:new {
	objectName = "@mob/creature_names:coa2_imperial_commander",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	mobType = MOB_NPC,
	socialGroup = "imperial",
	faction = "",
	level = 900,
	chanceHit = 44.00,
	damageMin = 4000,
	damageMax = 7100,
	baseXp = 640000,
	baseHAM = 640000,
	baseHAMmax = 820000,
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
	templates = {"object/mobile/dressed_dark_jedi_human_male_01.iff"},
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
	primaryAttacks = merge(brawlermaster,marksmanmaster,riflemanmaster),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(bh_max_contract_imperial_executor, "bh_max_contract_imperial_executor")
