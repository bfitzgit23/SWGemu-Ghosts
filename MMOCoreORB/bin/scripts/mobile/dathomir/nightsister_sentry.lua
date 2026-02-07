nightsister_sentry = Creature:new {
	objectName = "@mob/creature_names:nightsister_sentry",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "nightsister",
	faction = "nightsister",
	level = 27,
	chanceHit = 0.36,
	damageMin = 240,
	damageMax = 250,
	baseXp = 2730,
	baseHAM = 7200,
	baseHAMmax = 8800,
	armor = 0,
	resists = {15,15,15,60,60,60,60,-1,-1},
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
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/dressed_dathomir_nightsister_guardian.iff"},
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
	attacks = merge(fencernovice,swordsmannovice,tkamid,pikemanmid,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(nightsister_sentry, "nightsister_sentry")
