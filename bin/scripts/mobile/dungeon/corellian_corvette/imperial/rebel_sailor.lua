rebel_sailor = Creature:new {
	objectName = "@mob/creature_names:corvette_rebel_sailor",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "rebel",
	faction = "rebel",
	level = 96,
	chanceHit = 0.95,
	damageMin = 620,
	damageMax = 950,
	baseXp = 9150,
	baseHAM = 20000,
	baseHAMmax = 25000,
	armor = 0,
	resists = {45,45,0,0,30,30,80,65,-1},
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

	templates = {"object/mobile/dressed_rebel_crewman_human_female_01.iff",
		"object/mobile/dressed_rebel_crewman_human_female_02.iff",
		"object/mobile/dressed_rebel_crewman_human_male_01.iff",
		"object/mobile/dressed_rebel_crewman_human_male_02.iff",
		"object/mobile/dressed_rebel_crewman_human_male_03.iff",
		"object/mobile/dressed_rebel_crewman_human_male_04.iff"
	},
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
	weapons = {"rebel_weapons_medium"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/military",
	attacks = merge(riflemanmaster,carbineermaster,marksmanmaster,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(rebel_sailor, "rebel_sailor")
