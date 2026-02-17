kunga_loreweaver = Creature:new {
	objectName = "@mob/creature_names:kunga_loreweaver",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "kunga_tribe",
	faction = "kunga_tribe",
	level = 51,
	chanceHit = 0.48,
	damageMin = 425,
	damageMax = 560,
	baseXp = 5007,
	baseHAM = 9900,
	baseHAMmax = 12100,
	armor = 1,
	resists = {0,60,0,-1,-1,65,40,-1,-1},
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
	creatureBitmask = PACK + HERD + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {
		"object/mobile/dantari_male.iff",
		"object/mobile/dantari_female.iff"},
	lootGroups = {
		{
			groups = {
                {group = "junk", chance = 2250000}, -- 22.50%
                {group = "loot_kit_parts", chance = 2250000}, -- 22.50%
                {group = "armor_attachments", chance = 1000000}, -- 10.00%
                {group = "clothing_attachments", chance = 1000000}, -- 10.00%
                {group = "wearables_common", chance = 1250000}, -- 12.50%
                {group = "wearables_uncommon", chance = 1250000}, -- 12.50%
                {group = "power_crystals", chance = 1000000}, -- 10.00%
			}
		}
	},
	weapons = {"primitive_weapons"},
	conversationTemplate = "",
	attacks = merge(pikemanmaster,fencermaster,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(kunga_loreweaver, "kunga_loreweaver")
