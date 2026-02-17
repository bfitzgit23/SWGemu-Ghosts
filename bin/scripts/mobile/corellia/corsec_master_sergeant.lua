corsec_master_sergeant = Creature:new {
	objectName = "@mob/creature_names:corsec_master_sergeant",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "corsec",
	faction = "corsec",
	level = 18,
	chanceHit = 0.32,
	damageMin = 170,
	damageMax = 180,
	baseXp = 1257,
	baseHAM = 4100,
	baseHAMmax = 5000,
	armor = 0,
	resists = {0,0,0,0,0,0,0,-1,-1},
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
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {
		"object/mobile/dressed_corsec_officer_human_female_01.iff",
		"object/mobile/dressed_corsec_officer_human_male_01.iff",
		"object/mobile/dressed_corsec_pilot_human_male_01.iff"
	},
	lootGroups = {
		{
			groups = {
                {group = "corsec_weapons", chance = 1250000}, -- 12.50%
                {group = "wearables_common", chance = 1250000}, -- 12.50%
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

CreatureTemplates:addCreatureTemplate(corsec_master_sergeant, "corsec_master_sergeant")
