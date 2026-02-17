mokk_clan_leader = Creature:new {
	objectName = "@mob/creature_names:mokk_clan_leader",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "mokk_tribe",
	faction = "mokk_tribe",
	level = 75,
	chanceHit = 0.75,
	damageMin = 520,
	damageMax = 750,
	baseXp = 7207,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 0,
	resists = {0,60,-1,0,0,100,0,-1,-1},
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
	creatureBitmask = PACK + HERD + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/dantari_male.iff"},
	lootGroups = {
		{
			groups = {
                {group = "junk", chance = 2250000}, -- 22.50%
                {group = "loot_kit_parts", chance = 2250000}, -- 22.50%
                {group = "armor_attachments", chance = 1000000}, -- 10.00%
                {group = "clothing_attachments", chance = 1000000}, -- 10.00%
                {group = "wearables_all", chance = 2500000}, -- 25.00%
                {group = "color_crystals", chance = 1000000}, -- 10.00%
			}
		}
	},
	weapons = {"primitive_weapons"},
	conversationTemplate = "",
	attacks = merge(pikemanmaster,fencermaster,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(mokk_clan_leader, "mokk_clan_leader")
