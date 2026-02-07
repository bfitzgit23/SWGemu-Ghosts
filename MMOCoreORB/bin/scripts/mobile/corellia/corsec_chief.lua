corsec_chief = Creature:new {
	objectName = "@mob/creature_names:corsec_chief",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "corsec",
	faction = "corsec",
	level = 27,
	chanceHit = 0.37,
	damageMin = 260,
	damageMax = 270,
	baseXp = 2822,
	baseHAM = 8100,
	baseHAMmax = 9900,
	armor = 0,
	resists = {20,20,20,20,20,-1,-1,-1,-1},
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

	templates = {"object/mobile/dressed_corellia_local_corsec_chief.iff"},
	lootGroups = {
		{
			groups = {
				{group = "wearables_all", chance = 1250000}, -- 12.50%
				{group = "corsec_weapons", chance = 1250000}, -- 12.50%
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

CreatureTemplates:addCreatureTemplate(corsec_chief, "corsec_chief")
