feral_marauder = Creature:new {
	objectName = "@mob/creature_names:feral_marauder",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "endor_marauder",
	faction = "endor_marauder",
	level = 44,
	chanceHit = 0.47,
	damageMin = 345,
	damageMax = 400,
	baseXp = 4370,
	baseHAM = 10000,
	baseHAMmax = 12000,
	armor = 0,
	resists = {0,0,0,-1,0,0,-1,0,-1},
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
	scale = 1.35,

	templates = {"object/mobile/dressed_feral_marauder.iff"},
	lootGroups = {
		{
			groups = {
                {group = "pistols", chance = 277777}, -- 2.78%
                {group = "carbines", chance = 277777}, -- 2.78%
                {group = "rifles", chance = 277777}, -- 2.78%
                {group = "melee_baton", chance = 277777}, -- 2.78%
                {group = "loot_kit_parts", chance = 4500007}, -- 45.00%
                {group = "armor_attachments", chance = 1000000}, -- 10.00%
                {group = "clothing_attachments", chance = 1000000}, -- 10.00%
                {group = "bone_armor", chance = 277777}, -- 2.78%
                {group = "chitin_armor", chance = 277777}, -- 2.78%
                {group = "mabari_armor", chance = 277777}, -- 2.78%
                {group = "tantel_armor", chance = 277777}, -- 2.78%
                {group = "ubese_armor", chance = 277777}, -- 2.78%
                {group = "color_crystals", chance = 1000000}, -- 10.00%
			}
		}
	},
	weapons = {"pirate_weapons_heavy"},
	conversationTemplate = "",
	attacks = merge(riflemanmaster,pistoleermaster,carbineermaster,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(feral_marauder, "feral_marauder")
