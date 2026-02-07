kunga_warrior = Creature:new {
	objectName = "@mob/creature_names:kunga_warrior",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "kunga_tribe",
	faction = "kunga_tribe",
	level = 70,
	chanceHit = 0.7,
	damageMin = 495,
	damageMax = 700,
	baseXp = 6655,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {25,45,-1,25,25,100,25,-1,-1},
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
	creatureBitmask = PACK + HERD,
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

CreatureTemplates:addCreatureTemplate(kunga_warrior, "kunga_warrior")
