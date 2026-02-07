rebel_commodore = Creature:new {
	objectName = "@mob/creature_names:corvette_rebel_commodore",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "rebel",
	faction = "rebel",
	level = 181,
	chanceHit = 13,
	damageMin = 1045,
	damageMax = 1800,
	baseXp = 17178,
	baseHAM = 126000,
	baseHAMmax = 154000,
	armor = 2,
	resists = {65,75,40,40,30,30,80,65,-1},
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

	templates = {"object/mobile/dressed_rebel_commando_zabrak_female_01.iff"},
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
                {group = "rebel_officer_common", chance = 1500000}, -- 15.00%
                {group = "wearables_rare", chance = 1500000}, -- 15.00%
			}
		}
	},
	weapons = {"rebel_weapons_heavy"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/military",
	attacks = merge(commandomaster,marksmanmaster,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(rebel_commodore, "rebel_commodore")
