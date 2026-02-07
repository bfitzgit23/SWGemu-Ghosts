donkuwah_chieftain = Creature:new {
	objectName = "@mob/creature_names:donkuwah_chieftan",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "donkuwah_tribe",
	faction = "donkuwah_tribe",
	level = 58,
	chanceHit = 0.57,
	damageMin = 430,
	damageMax = 570,
	baseXp = 5647,
	baseHAM = 11000,
	baseHAMmax = 14000,
	armor = 0,
	resists = {15,50,0,0,0,-1,-1,0,-1},
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

	templates = {"object/mobile/dulok_male.iff"},
	lootGroups = {
		{
			groups = {
                {group = "donkuwah_common", chance = 3500000}, -- 35.00%
                {group = "wearables_uncommon", chance = 3500000}, -- 35.00%
                {group = "armor_attachments", chance = 1500000}, -- 15.00%
                {group = "clothing_attachments", chance = 1500000}, -- 15.00%	
			},
		}
	},
	weapons = {"donkuwah_weapons"},
	conversationTemplate = "",
	attacks = merge(fencermaster,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(donkuwah_chieftain, "donkuwah_chieftain")
