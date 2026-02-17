rebel_rear_admiral = Creature:new {
	objectName = "@mob/creature_names:corvette_rebel_rear_admiral",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "rebel",
	faction = "rebel",
	level = 200,
	chanceHit = 16,
	damageMin = 1145,
	damageMax = 2000,
	baseXp = 19008,
	baseHAM = 160000,
	baseHAMmax = 195000,
	armor = 3,
	resists = {70,75,0,0,30,30,80,65,-1},
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

	templates = {"object/mobile/dressed_rebel_high_general_sullustan_male_01.iff",
		"object/mobile/dressed_rebel_high_general_old_twilek_female_01.iff",
		"object/mobile/dressed_rebel_high_general_human_male_02.iff",
		"object/mobile/dressed_rebel_high_general_human_female_01.iff",
		"object/mobile/dressed_rebel_high_general_moncal_male_01.iff"
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
	weapons = {"rebel_weapons_heavy"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/military",
	attacks = merge(commandomaster,marksmanmaster,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(rebel_rear_admiral, "rebel_rear_admiral")
