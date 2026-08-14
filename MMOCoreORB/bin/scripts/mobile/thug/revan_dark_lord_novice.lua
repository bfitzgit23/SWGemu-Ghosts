-- Coded by BoosterSteel 19-03-2026
-- Revan Dark Lord Novice
-- Phase 1 Master Trial for Dark Jedi players
-- Level 300 - solo challenge for a geared Knight

revan_dark_lord_novice = Creature:new {
	customName = "Revan - Dark Lord Novice",
	socialGroup = "dark_jedi",
	pvpFaction = "",
	faction = "",
	level = 300,
	chanceHit = 30.00,
	damageMin = 1800,
	damageMax = 3310,
	baseXp = 278490,
	baseHAM = 421000,
	baseHAMmax = 592000,
	armor = 3,
	resists = {45,45,45,45,45,45,45,45,45},
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
				{group = "wearables_all",     chance = 5000000},
				{group = "loot_kit_parts",    chance = 2500000},
				{group = "tailor_components", chance = 2500000}
			},
			lootChance = 10000000
		},
		{
			groups = {
				{group = "tierone",     chance = 3500000},
				{group = "tiertwo",     chance = 3500000},
				{group = "tierthree",   chance = 1500000},
				{group = "tierdiamond", chance = 1500000},
			},
			lootChance = 10000000
		},
	},
	weapons = {"dark_jedi_weapons_gen4"},
	reactionStf = "@npc_reaction/slang",
	attacks = merge(lightsabermaster)
}

CreatureTemplates:addCreatureTemplate(revan_dark_lord_novice, "revan_dark_lord_novice")
