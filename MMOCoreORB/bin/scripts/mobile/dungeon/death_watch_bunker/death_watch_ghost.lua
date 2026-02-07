death_watch_ghost = Creature:new {
	objectName = "@mob/creature_names:mand_bunker_dthwatch_grey",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "death_watch",
	faction = "",
	level = 222,
	chanceHit = 8.5,
	damageMin = 895,
	damageMax = 1500,
	baseXp = 14314,
	baseHAM = 187000,
	baseHAMmax = 187000,
	armor = 2,
	resists = {65,65,70,60,35,35,100,50,-1},
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

	templates = {"object/mobile/dressed_death_watch_grey.iff"},
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
	attacks = merge(bountyhuntermaster,marksmanmaster,brawlermaster,pikemanmaster,fencermaster,swordsmanmaster)
}

CreatureTemplates:addCreatureTemplate(death_watch_ghost, "death_watch_ghost")
