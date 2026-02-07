death_watch_black_sun_thug = Creature:new {
	objectName = "@mob/creature_names:mand_bunker_blksun_thug",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "death_watch",
	faction = "",
	level = 186,
	chanceHit = 0.85,
	damageMin = 570,
	damageMax = 850,
	baseXp = 8130,
	baseHAM = 30000,
	baseHAMmax = 30000,
	armor = 1,
	resists = {40,40,60,35,55,70,35,40,-1},
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

	templates = {"object/mobile/dressed_black_sun_thug.iff"},
	lootGroups = {
		{
			groups = {
                {group = "death_watch_bunker_commoners", chance = 625000}, -- 6.25%
                {group = "pistols", chance = 833333}, -- 8.33%
                {group = "rifles", chance = 833333}, -- 8.33%
                {group = "carbines", chance = 833333}, -- 8.33%
                {group = "wearables_uncommon", chance = 5250001}, -- 52.50%	
				{group = "clothing_attachments", chance = 500000}, -- 5.00%
				{group = "armor_attachments", chance = 500000}, -- 5.00%			
			},
		}
	},
	weapons = {"pirate_weapons_heavy"},
	conversationTemplate = "",
	attacks = merge(bountyhuntermaster,marksmanmaster,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(death_watch_black_sun_thug, "death_watch_black_sun_thug")
