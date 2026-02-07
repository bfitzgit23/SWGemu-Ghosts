novatrooper = Creature:new {
	objectName = "@mob/creature_names:stormtrooper_novatrooper",
	randomNameType = NAME_STORMTROOPER,
	randomNameTag = true,
	socialGroup = "imperial",
	faction = "imperial",
	level = 97,
	chanceHit = 0.95,
	damageMin = 620,
	damageMax = 950,
	baseXp = 9243,
	baseHAM = 20000,
	baseHAMmax = 25000,
	armor = 1,
	resists = {40,35,80,30,30,30,30,45,-1},
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

	templates = {"object/mobile/dressed_stormtrooper_black_gold.iff"},
	lootGroups = {
		{
			groups = {
                {group = "color_crystals", chance = 1000000}, -- 10.00%
                {group = "junk", chance = 1500000}, -- 15.00%
                {group = "rifles", chance = 625000}, -- 6.25%
                {group = "pistols", chance = 625000}, -- 6.25%
                {group = "melee_weapons", chance = 625000}, -- 6.25%
                {group = "carbines", chance = 625000}, -- 6.25%
                {group = "clothing_attachments", chance = 1000000}, -- 10.00%
                {group = "armor_attachments", chance = 1000000}, -- 10.00%
                {group = "wearables_common", chance = 1500000}, -- 15.00%
                {group = "wearables_uncommon", chance = 1500000}, -- 15.00%
			}
		}
	},
	weapons = {"stormtrooper_weapons"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/stormtrooper",
	attacks = merge(riflemanmaster,carbineermaster,marksmanmaster,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(novatrooper, "novatrooper")
