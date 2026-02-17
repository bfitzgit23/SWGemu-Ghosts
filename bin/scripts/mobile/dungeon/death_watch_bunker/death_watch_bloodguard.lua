death_watch_bloodguard = Creature:new {
	objectName = "@mob/creature_names:mand_bunker_dthwatch_red",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "death_watch",
	faction = "",
	level = 201,
	chanceHit = 4,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 90000,
	baseHAMmax = 90000,
	armor = 2,
	resists = {55,55,70,60,30,30,100,40,-1},
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

	templates = {"object/mobile/dressed_death_watch_red.iff"},
	lootGroups = {
		{
			groups = {
                {group = "death_watch_bunker_commoners", chance = 625000}, -- 6.25%
                {group = "death_watch_bunker_lieutenants", chance = 625000}, -- 6.25%
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
	attacks = merge(bountyhuntermaster,marksmanmaster,brawlermaster,tkamaster)
}

CreatureTemplates:addCreatureTemplate(death_watch_bloodguard, "death_watch_bloodguard")
