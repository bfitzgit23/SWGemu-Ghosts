death_watch_wraith = Creature:new {
	objectName = "@mob/creature_names:mand_bunker_dthwatch_silver",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "death_watch",
	faction = "",
	level = 248,
	chanceHit = 12.25,
	damageMin = 1020,
	damageMax = 1750,
	baseXp = 16794,
	baseHAM = 204000,
	baseHAMmax = 204000,
	armor = 2,
	resists = {75,75,90,80,45,45,100,70,-1},
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
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	scale = 1.15,

	templates = {"object/mobile/dressed_death_watch_silver.iff"},
	lootGroups = {
		{
			groups = {
                {group = "death_watch_bunker_commoners", chance = 312500}, -- 3.12%
                {group = "death_watch_bunker_lieutenants", chance = 312500}, -- 3.12%
                {group = "death_watch_bunker_ingredient_protective", chance = 312500}, -- 3.12%
                {group = "death_watch_bunker_ingredient_binary", chance = 312500}, -- 3.12%
                {group = "pistols", chance = 833333}, -- 8.33%
                {group = "rifles", chance = 833333}, -- 8.33%
                {group = "carbines", chance = 833333}, -- 8.33%
                {group = "wearables_uncommon", chance = 3250001}, -- 32.50%
                {group = "clothing_attachments", chance = 1500000}, -- 15.00%
                {group = "armor_attachments", chance = 1500000}, -- 15.00%
			},
		}
	},
	weapons = {"pirate_weapons_heavy"},
	conversationTemplate = "",
	attacks = merge(bountyhuntermaster,marksmanmaster,brawlermaster,swordsmanmaster,pistoleermaster,fencermaster,pikemanmaster,riflemanmaster)
}

CreatureTemplates:addCreatureTemplate(death_watch_wraith, "death_watch_wraith")
