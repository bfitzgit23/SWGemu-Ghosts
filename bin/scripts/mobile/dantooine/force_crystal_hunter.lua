force_crystal_hunter = Creature:new {
	objectName = "@mob/creature_names:dark_force_crystal_hunter",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "kun",
	faction = "",
	level = 115,
	chanceHit = 1,
	damageMin = 820,
	damageMax = 1350,
	baseXp = 10921,
	baseHAM = 24000,
	baseHAMmax = 30000,
	armor = 2,
	resists = {80,80,80,80,80,80,80,80,-1},
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
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/dressed_dark_force_crystal_hunter.iff"},
	lootGroups = {
		{
			groups = {
                {group = "junk", chance = 3331251}, -- 33.31%
                {group = "power_crystals", chance = 831250}, -- 8.31%
                {group = "color_crystals", chance = 831250}, -- 8.31%
                {group = "holocron_dark", chance = 300000}, -- 3.00%
                {group = "holocron_light", chance = 300000}, -- 3.00%
                {group = "melee_weapons", chance = 914583}, -- 9.15%
                {group = "armor_attachments", chance = 831250}, -- 8.31%
                {group = "clothing_attachments", chance = 831250}, -- 8.31%
                {group = "wearables_all", chance = 914583}, -- 9.15%
                {group = "force_hunter_rare", chance = 914583}, -- 9.15%
			}
		}
	},
	weapons = {"mixed_force_weapons"},
	conversationTemplate = "",
	attacks = merge(pikemanmaster,brawlermaster,fencermaster,swordsmanmaster,forcewielder)
}

CreatureTemplates:addCreatureTemplate(force_crystal_hunter, "force_crystal_hunter")
