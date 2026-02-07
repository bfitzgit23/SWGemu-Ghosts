dantari_chief = Creature:new {
	objectName = "@mob/creature_names:dantari_raider_chief",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "dantari_raiders",
	faction = "dantari_raiders",
	level = 42,
	chanceHit = 0.44,
	damageMin = 345,
	damageMax = 400,
	baseXp = 4188,
	baseHAM = 9300,
	baseHAMmax = 11300,
	armor = 0,
	resists = {35,50,50,-1,70,70,-1,0,-1},
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

	templates = {"object/mobile/dantari_male.iff"},
	lootGroups = {
		{
			groups = {
                {group = "junk", chance = 2250000}, -- 22.50%
                {group = "loot_kit_parts", chance = 2250000}, -- 22.50%
                {group = "armor_attachments", chance = 1500000}, -- 15.00%
                {group = "clothing_attachments", chance = 1500000}, -- 15.00%
                {group = "wearables_all", chance = 2500000}, -- 25.00%
			}
		}
	},
	weapons = {"primitive_weapons"},
	conversationTemplate = "",
	attacks = merge(pikemanmaster,fencermaster,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(dantari_chief, "dantari_chief")
