imperial_observer = Creature:new {
	objectName = "@mob/creature_names:geonosian_imperial_observer",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "imperial",
	faction = "imperial",
	level = 53,
	chanceHit = 0.54,
	damageMin = 415,
	damageMax = 540,
	baseXp = 5190,
	baseHAM = 11000,
	baseHAMmax = 13000,
	armor = 1,
	resists = {5,5,5,5,5,5,5,5,-1},
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
		"object/mobile/dressed_imperial_officer_m.iff",
		"object/mobile/dressed_imperial_officer_m_2.iff",
		"object/mobile/dressed_imperial_officer_m_3.iff",
		"object/mobile/dressed_imperial_officer_m_4.iff",
		"object/mobile/dressed_imperial_officer_m_5.iff",
		"object/mobile/dressed_imperial_officer_m_6.iff"},
	lootGroups = {
		{
			groups = {
                {group = "clothing_attachments", chance = 1500000}, -- 15.00%
                {group = "armor_attachments", chance = 1500000}, -- 15.00%
                {group = "geonosian_hard", chance = 1000000}, -- 10.00%
                {group = "geonosian_common", chance = 2500000}, -- 25.00%
                {group = "geonosian_relic", chance = 3500000}, -- 35.00%
			}
		}
	},
	weapons = {"imperial_weapons_heavy"},
	conversationTemplate = "",
	attacks = merge(brawlermaster,marksmanmaster,riflemanmaster,carbineermaster)
}

CreatureTemplates:addCreatureTemplate(imperial_observer, "imperial_observer")
