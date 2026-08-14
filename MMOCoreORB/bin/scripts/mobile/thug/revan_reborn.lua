-- Revan Reborn - Phase 2 Master Trial Boss
-- 75% stronger than revan_clone
-- Double crystal loot groups

revan_reborn = Creature:new {
	customName = "Revan (Reborn)",
	socialGroup = "dark_jedi",
	pvpFaction = "",
	faction = "",
	level = 525,                      -- 300 * 1.75
	chanceHit = 52.50,                -- 30.00 * 1.75
	damageMin = 3150,                 -- 1800 * 1.75
	damageMax = 5793,                 -- 3310 * 1.75
	baseXp = 487358,                  -- 278490 * 1.75
	baseHAM = 736750,                 -- 421000 * 1.75
	baseHAMmax = 1036000,             -- 592000 * 1.75
	armor = 3,
	resists = {79,79,79,79,79,79,79,79,79},  -- 45 * 1.75 capped at 80
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0.0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	templates = {"object/mobile/som/blackguard_wilder.iff"},
	lootGroups = {
		{
			groups = {
				{group = "junk",        chance = 5000000},
				{group = "armor_all",   chance = 4500000},
				{group = "weapons_all", chance = 500000}
			},
			lootChance = 10000000
		},
		{
			groups = {
				{group = "wearables_all",    chance = 5000000},
				{group = "loot_kit_parts",   chance = 2500000},
				{group = "tailor_components",chance = 2500000}
			},
			lootChance = 10000000
		},
		-- Double crystal loot groups (two separate rolls)
		{
			groups = {
				{group = "tierone",    chance = 3500000},
				{group = "tiertwo",    chance = 3500000},
				{group = "tierthree", chance = 1500000},
				{group = "tierdiamond",chance = 1500000},
			},
			lootChance = 10000000
		},
		{
			groups = {
				{group = "tierone",    chance = 3500000},
				{group = "tiertwo",    chance = 3500000},
				{group = "tierthree", chance = 1500000},
				{group = "tierdiamond",chance = 1500000},
			},
			lootChance = 10000000
		},
	},
	weapons = {"dark_jedi_weapons_gen4"},
	reactionStf = "@npc_reaction/slang",
	attacks = merge(lightsabermaster)
}
CreatureTemplates:addCreatureTemplate(revan_reborn, "revan_reborn")
