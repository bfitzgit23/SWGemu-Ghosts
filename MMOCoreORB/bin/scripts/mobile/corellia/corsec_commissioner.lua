corsec_commissioner = Creature:new {
	objectName = "@mob/creature_names:corsec_comissioner",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "corsec",
	faction = "corsec",
	level = 30,
	chanceHit = 0.39,
	damageMin = 290,
	damageMax = 300,
	baseXp = 3097,
	baseHAM = 8400,
	baseHAMmax = 10200,
	armor = 0,
	resists = {0,0,0,0,0,0,-1,-1,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {
		"object/mobile/dressed_corsec_detective_human_male_01.iff",
		"object/mobile/dressed_corsec_detective_human_female_01.iff",
		"object/mobile/dressed_corsec_captain_human_female_01.iff"
	},
	lootGroups = {
		{
			groups = {
				{group = "corsec_weapons", chance = 1250000}, -- 12.50%
				{group = "wearables_all", chance = 1250000}, -- 12.50%
				{group = "junk", chance = 3750000}, -- 37.50%
				{group = "tailor_components", chance = 3750000}, -- 37.50%
			}
		}
	},
	weapons = {"corsec_police_weapons"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/military",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(corsec_commissioner, "corsec_commissioner")
