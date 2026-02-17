nightsister_outcast = Creature:new {
	objectName = "@mob/creature_names:nightsister_outcast",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "nightsister",
	faction = "nightsister",
	level = 81,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 7761,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {30,30,30,100,100,100,100,100,-1},
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

	templates = {"object/mobile/dressed_dathomir_nightsister_outcast.iff"},
	lootGroups = {
		{
			groups = {
                {group = "power_crystals", chance = 750000}, -- 7.50%
                {group = "color_crystals", chance = 750000}, -- 7.50%
                {group = "nightsister_common", chance = 2250000}, -- 22.50%
                {group = "armor_attachments", chance = 750000}, -- 7.50%
                {group = "clothing_attachments", chance = 750000}, -- 7.50%
                {group = "melee_weapons", chance = 500000}, -- 5.00%
                {group = "rifles", chance = 500000}, -- 5.00%
                {group = "pistols", chance = 500000}, -- 5.00%
                {group = "carbines", chance = 500000}, -- 5.00%
                {group = "wearables_common", chance = 500000}, -- 5.00%
                {group = "tailor_components", chance = 2250000}, -- 22.50%
			}
		}
	},
	weapons = {"mixed_force_weapons"},
	conversationTemplate = "",
	attacks = merge(fencermid,swordsmanmid,tkamid,pikemanmaster,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(nightsister_outcast, "nightsister_outcast")
