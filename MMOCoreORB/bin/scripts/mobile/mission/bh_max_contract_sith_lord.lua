-- Ghosts: maximum-tier bounty contract target (CL 900).
-- Spawned only by the investigation_03 / master bounty hunter mission tier.
bh_max_contract_sith_lord = Creature:new {
	objectName = "@mob/creature_names:dark_jedi_master",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	mobType = MOB_NPC,
	socialGroup = "dark_jedi",
	faction = "",
	level = 900,
	chanceHit = 46.00,
	damageMin = 4200,
	damageMax = 7400,
	baseXp = 660000,
	baseHAM = 680000,
	baseHAMmax = 860000,
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
	primaryWeapon = "dark_jedi_weapons_gen2",
	secondaryWeapon = "dark_jedi_weapons_ranged",
	conversationTemplate = "",
	primaryAttacks = lightsabermaster,
	secondaryAttacks = forcewielder
}

CreatureTemplates:addCreatureTemplate(bh_max_contract_sith_lord, "bh_max_contract_sith_lord")
