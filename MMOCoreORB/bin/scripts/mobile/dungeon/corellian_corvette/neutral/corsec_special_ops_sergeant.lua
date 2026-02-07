corsec_special_ops_sergeant = Creature:new {
	objectName = "@mob/creature_names:corsec_sergeant_aggro",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "corsec",
	faction = "corsec",
	level = 96,
	chanceHit = 0.95,
	damageMin = 620,
	damageMax = 950,
	baseXp = 9150,
	baseHAM = 20000,
	baseHAMmax = 25000,
	armor = 2,
	resists = {45,45,30,0,80,30,0,35,-1},
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

	templates = { "object/mobile/dressed_corsec_officer_human_male_01.iff",
		"object/mobile/dressed_corsec_officer_human_female_01.iff"},
	lootGroups = {
		{
			groups = {
                {group = "color_crystals", chance = 1000000}, -- 10.00%
                {group = "junk", chance = 1400000}, -- 14.00%
                {group = "weapons_all", chance = 1400000}, -- 14.00%
                {group = "armor_all", chance = 1400000}, -- 14.00%
                {group = "clothing_attachments", chance = 1000000}, -- 10.00%
                {group = "armor_attachments", chance = 1000000}, -- 10.00%
                {group = "rebel_officer_common", chance = 1400000}, -- 14.00%
                {group = "wearables_all", chance = 1400000}, -- 14.00%
			}
		}
	},
	weapons = {"corsec_police_weapons"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/military",
	attacks = merge(riflemanmaster,pistoleermaster,carbineermaster,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(corsec_special_ops_sergeant, "corsec_special_ops_sergeant")
