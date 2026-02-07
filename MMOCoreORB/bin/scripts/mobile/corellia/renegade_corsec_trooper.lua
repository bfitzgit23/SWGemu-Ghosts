renegade_corsec_trooper = Creature:new {
	objectName = "@mob/creature_names:corsec_renegade",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "rogue_corsec",
	faction = "rogue_corsec",
	level = 12,
	chanceHit = 0.29,
	damageMin = 130,
	damageMax = 140,
	baseXp = 609,
	baseHAM = 1200,
	baseHAMmax = 1400,
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
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {
		"object/mobile/dressed_corsec_captain_human_female_01.iff",
		"object/mobile/dressed_corsec_captain_human_male_01.iff"},
	lootGroups = {
		{
			groups = {
                {group = "corsec_weapons", chance = 2500000}, -- 25.00%
                {group = "junk", chance = 3750000}, -- 37.50%
                {group = "tailor_components", chance = 3750000}, -- 37.50%
			}
		}
	},
	weapons = {"ranged_weapons"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermid,marksmanmid)
}

CreatureTemplates:addCreatureTemplate(renegade_corsec_trooper, "renegade_corsec_trooper")
